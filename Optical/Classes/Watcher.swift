//
//  Watcher.swift
//  Optical
//
//  Created by Geektree0101 on 07/27/19.
//  Copyright © 2019 Geektree0101. All rights reserved.

import Dispatch
import Foundation.NSLock

public protocol WatchControlable: class {
  
  func subscribe()
  func unsubscribe()
}

public class Watcher<State>: WatchControlable {
  
  private var _lock: NSRecursiveLock = .init()
  private var _handler: ((State) -> Void)?
  private var _filter: ((State) -> Bool)?
  private var _queue: DispatchQueue = DispatchQueue.main
  private var _isLiveAvaliable: Bool = true
  
  internal var _state: State? {
    didSet {
      guard let _validState = self._state,
        self._isLiveAvaliable == true else { return }
      
      if let predicateFilter = _filter,
        predicateFilter(_validState) == false {
        return
      }
      
      self._queue.async { [weak self] in
        self?._handler?(_validState)
      }
    }
  }
  
  public func subscribe() {
    _lock.lock(); defer { _lock.unlock() }
    _isLiveAvaliable = true
  }
  
  public func unsubscribe() {
    _lock.lock(); defer { _lock.unlock() }
    _isLiveAvaliable = false
  }
}

extension Watcher {

  @discardableResult
  public func live(on queue: DispatchQueue = DispatchQueue.main,
            _ handler: @escaping (State) -> Void) -> WatchControlable {
    _lock.lock(); defer { _lock.unlock() }
    self._queue = queue
    self._handler = handler
    return self
  }
  
  public func map<R>(on queue: DispatchQueue = DispatchQueue.main,
                     _ transform: @escaping (State) -> R) -> Watcher<R> {
    let watcher = Watcher<R>.init()
    self.live(on: queue, { state in
      watcher._state = transform(state)
    })
    return watcher
  }
  
  public func filter(on queue: DispatchQueue = DispatchQueue.main,
                     _ predicate: @escaping (State) -> Bool) -> Watcher<State> {
    _lock.lock(); defer { _lock.unlock() }
    self._filter = predicate
    return self
  }
}
