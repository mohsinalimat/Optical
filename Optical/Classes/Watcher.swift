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
  private var _filter: ((State) -> Bool)?
  private var _queue: DispatchQueue = DispatchQueue.main
  
  internal var _state: State? {
    didSet {
      guard let _validState = self._state else { return }
      
      if let predicateFilter = _filter,
        predicateFilter(_validState) == false {
        return
      }
      
      self._queue.async { [weak self] in
        self?._handler?(_validState)
      }
    }
  }
}

extension Watcher {

  public func live(on queue: DispatchQueue = DispatchQueue.main,
            _ handler: @escaping (State) -> Void) {
    _lock.lock(); defer { _lock.unlock() }
    self._queue = queue
    self._handler = handler
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
