//
//  HistoryListOpticle.swift
//  Optical_Example
//
//  Created by Hyeon su Ha on 28/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Optical

final class HistoryListOpticle: Opticle {
  
  enum Request {
    case reload
    case loadMore
  }
  
  enum Response {
    case reloadItems([History])
    case appendItems([History])
  }
  
  struct State {
    
    var items: [HistoryListCellOpticle]
    var hasNextPage: Bool
  }
  
  var state: State = .init(items: [], hasNextPage: true)
  
  func dispatch(_ request: Request) {
    switch request {
    case .reload:
      commit(.reloadItems([.init(id: 1, title: "apple", isFollow: false),
                           .init(id: 2, title: "banana", isFollow: false),
                           .init(id: 3, title: "cherry", isFollow: true)]))
    case .loadMore:
      commit(.appendItems([.init(id: 4, title: "durian", isFollow: false),
                           .init(id: 5, title: "egg", isFollow: true),
                           .init(id: 6, title: "fig", isFollow: false)]))
    }
  }
  
  func mutate(_ state: State, response: Response) -> State {
    var newState = state
    
    switch response {
    case .reloadItems(let histories):
      newState.items = histories.map({
        let opticle = HistoryListCellOpticle.init()
        opticle.state = .init(title: $0.title, isFollow: $0.isFollow, history: $0)
        return opticle
      })
      newState.hasNextPage = true
      
    case .appendItems(let histories):
      newState.items += histories.map({
        let opticle = HistoryListCellOpticle.init()
        opticle.state = .init(title: $0.title, isFollow: $0.isFollow, history: $0)
        return opticle
      })
      newState.hasNextPage = false
    }
    
    return newState 
  }
}
