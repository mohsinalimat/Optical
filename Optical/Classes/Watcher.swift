//
//  Watcher.swift
//  Optical
//
//  Created by Geektree0101 on 07/27/19.
//  Copyright © 2019 Geektree0101. All rights reserved.

import Dispatch
import Foundation.NSLock

public class Watcher<State> {
  
  private var _lock: NSRecursiveLock = .init()
  private var _handler: ((State) -> Void)?
  private var _queue: DispatchQueue = DispatchQueue.main
  private var _isMounted: Bool = true
  
  internal var _filter: ((State) -> Bool)?
  internal var _sync: ((State) -> Void)?
  
  public func mount() {
    _lock.lock(); defer { _lock.unlock() }
    _isMounted = true
  }
  
  public func unmount() {
    _lock.lock(); defer { _lock.unlock() }
    _isMounted = false
  }
  
  public func render(on queue: DispatchQueue = DispatchQueue.main,
                     _ handler: @escaping (State) -> Void) {
    
    _lock.lock(); defer { _lock.unlock() }
    guard _isMounted == true else { return }
    
    self._queue = queue
    self._handler = handler
    
    _sync = { [weak self] newState in
      if let handler = self?._filter, handler(newState) == false {
        return
      }
      
      guard let handler = self?._handler else { return }
      self?._queue.async {
        handler(newState)
      }
    }
  }
}
