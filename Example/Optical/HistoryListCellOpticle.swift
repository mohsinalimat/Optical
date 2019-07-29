//
//  TestViewCellOpticle.swift
//  Optical_Example
//
//  Created by Hyeon su Ha on 28/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Optical

final class HistoryListCellOpticle: Opticle {
  
  enum Request {
    case updateTitle(String)
    case didTapFollow(Bool)
  }
  
  enum Response {
    case title(String)
    case followStatus(Bool)
  }
  
  struct State {
    var title: String
    var isFollow: Bool
    var history: History?
  }
  
  var state: HistoryListCellOpticle.State = .init(title: "", isFollow: false, history: nil)
  
  func dispatch(_ request: HistoryListCellOpticle.Request) {
    switch request {
    case .updateTitle(let newTitle):
      state.history?.title = newTitle
      self.commit(.title(newTitle))
    case .didTapFollow(let isFollow):
      self.commit(.followStatus(isFollow))
    }
  }
  
  func mutate(_ state: HistoryListCellOpticle.State,
              response: HistoryListCellOpticle.Response) -> HistoryListCellOpticle.State {
    var newState = state
    
    switch response {
    case .title(let newTitle):
      newState.title = newTitle
    case .followStatus(let isFollow):
      newState.isFollow = isFollow
      newState.history?.isFollow = isFollow
    }
    
    return newState
  }
}
