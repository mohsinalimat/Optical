//
//  TestViewCell.swift
//  Optical_Example
//
//  Created by Hyeon su Ha on 28/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class HistoryListCell: UITableViewCell {
  
  enum Const {
    static let identifier: String = "TestViewCell"
    static let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15.0)]
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var followButton: UIButton! {
    didSet {
      followButton.setTitle("Follow", for: .normal)
      followButton.setTitle("Unfollow", for: .selected)
      followButton.setTitleColor(.blue, for: .normal)
      followButton.setTitleColor(.white, for: .selected)
    }
  }
  
  weak var opticle: HistoryListCellOpticle? {
    didSet {
      render(opticle?.state)
      
      opticle?.watch.live({ [weak self] in
        self?.render($0)
      })
    }
  }
  
  weak var historyListOpticle: HistoryListOpticle?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    followButton.isSelected = false
    titleLabel.text = nil
  }
  
  private func render(_ state: HistoryListCellOpticle.State?) {
    titleLabel.text = state?.title
    followButton.isSelected = state?.isFollow ?? false
  }
  
  @IBAction func didTapFollow(_ sender: Any) {
    opticle?.dispatch(.didTapFollow(self.followButton.isSelected == false))
  }
  
}
