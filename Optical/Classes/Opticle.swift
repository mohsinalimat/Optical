//
//  Opticle.swift
//  Optical
//
//  Created by Geektree0101 on 07/27/19.
//  Copyright © 2019 Geektree0101. All rights reserved.

import Dispatch
import Foundation.NSLock

// MARK: - definitions

public protocol Opticle: class, AssociatedObjectStorable {
  
  associatedtype State
  associatedtype Request
  associatedtype Response
  var state: State { get set }
  func dispatch(_ request: Request)
  func recover(_ state: State, request: Request, error: Error?) -> State
  func mutate(_ state: State, response: Response) -> State
}

extension Opticle {
  
  public func recover(_ state: State, request: Request, error: Error?) -> State {
    
    return state
  }
  
  public func mutate(_ state: State, response: Response) -> State {
    
    return state
  }
  
  public var watch: Watcher<State> {
    let watcher = Watcher<State>.init()
    _lock.lock()
    _watchers.append(watcher)
    _lock.unlock()
    return watcher
  }
}

// MARK: - commit

extension Opticle {
  
  public func commit(_ response: Response) {
    
    let newState = mutate(
      state,
      response: response
    )
    
    self._syncronize_commit(newState)
  }
  
  public func commit(error: Error?, from request: Request) {
    
    let newState = recover(
      state,
      request: request,
      error: error
    )
    
    self._syncronize_commit(newState)
  }
}

// MARK: - private key props

private var opticalWatchers = "optical.watchers"
private var opticalState = "optical.state"
private var opticalLock = "optical.lock"
private var opticalCommitSyncronizeLock = "optical.commit_syncronize_lock"

// MARK: - private services

extension Opticle {

  private var _lock: NSRecursiveLock  {
    get { return self.associatedObject(forKey: &opticalLock, default: NSRecursiveLock.init()) }
    set { self.setAssociatedObject(newValue, forKey: &opticalLock) }
  }
  
  private var _syncronize_lock: NSRecursiveLock  {
    get { return self.associatedObject(forKey: &opticalCommitSyncronizeLock, default: NSRecursiveLock.init()) }
    set { self.setAssociatedObject(newValue, forKey: &opticalCommitSyncronizeLock) }
  }
  
  private var _watchers: [Watcher<State>] {
    get { return self.associatedObject(forKey: &opticalWatchers, default: []) }
    set { self.setAssociatedObject(newValue, forKey: &opticalWatchers) }
  }
  
  private func _syncronize_commit(_ newState: State) {
    _syncronize_lock.lock(); defer { _syncronize_lock.unlock() }
    self.state = newState
    
    _watchers.forEach({ watcher in
      _lock.lock()
      watcher._state = newState
      _lock.unlock()
    })
  }
}
