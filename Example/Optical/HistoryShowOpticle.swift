//
//  HistoryShowOpticle.swift
//  Optical_Example
//
//  Created by Hyeon su Ha on 28/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Optical

class HistoryShowOpticle: Opticle {
  
  enum Request {
    case reload
    case submit(String)
  }
  
  enum Response {
    case updatedHistory(History)
    case editedHistory(History)
  }
  
  struct State {
    
    enum Status {
      case pending
      case edited
      case error(Error?)
    }
    
    var status: Status = .pending
    var title: String {
      return history?.title ?? ""
    }
    var message: String?
    var history: History?
  }
  
  var state: HistoryShowOpticle.State = .init(status: .pending, message: nil, history: nil)
  
  func dispatch(_ request: HistoryShowOpticle.Request) {
    switch request {
    case .submit(let newTitle):
      if var history = state.history,
        history.title != newTitle,
        newTitle.isEmpty == false {
        history.title = newTitle
        self.commit(.editedHistory(history))
      } else {
        self.commit(error: NSError.init(domain: "error", code: 0, userInfo: nil), from: request)
      }
    case .reload:
      if let history = state.history {
        self.commit(.updatedHistory(history))
      } else {
        self.commit(error: NSError.init(domain: "error", code: 0, userInfo: nil), from: request)
      }
    }
  }
  
  func mutate(_ state: HistoryShowOpticle.State,
              response: HistoryShowOpticle.Response) -> HistoryShowOpticle.State {
    var newState = state
    
    switch response {
    case .updatedHistory(let newHistory):
      newState.status = .pending
      newState.history = newHistory
      newState.message = nil
    case .editedHistory(let newHistory):
      newState.status = .edited
      newState.history = newHistory
      newState.message = nil
    }
    
    return newState
  }
  
  func recover(_ state: HistoryShowOpticle.State,
               request: HistoryShowOpticle.Request,
               error: Error?) -> HistoryShowOpticle.State {
    var newState = state
    
    switch request {
    case .submit:
      newState.message = "Invalid Title"
      newState.status = .error(error)
    case .reload:
      newState.message = "History not found!"
      newState.status = .error(error)
    }
    
    return newState
  }
}
