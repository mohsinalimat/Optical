import UIKit

class HistoryListController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 40.0)
    }
  }
  
  private lazy var headerView: UILabel = {
    let label = UILabel.init(frame: .zero)
    let paragraph = NSMutableParagraphStyle.init()
    paragraph.headIndent = 20.0
    paragraph.firstLineHeadIndent = 20.0
    label.attributedText = NSAttributedString
      .init(string: "History",
            attributes: [.font: UIFont.systemFont(ofSize: 35.0),
                         .foregroundColor: UIColor.black,
                         .paragraphStyle: paragraph])
    return label
  }()
  
  private lazy var loadMoreButton: UIButton = {
    let button = UIButton.init(type: .system)
    button.setTitle("More See", for: .normal)
    button.addTarget(self, action: #selector(didTapLoadMore), for: .touchUpInside)
    return button
  }()
  
  private lazy var loadEndedLabel: UILabel = {
    let label = UILabel.init(frame: .zero)
    label.textAlignment = .center
    label.attributedText = NSAttributedString
      .init(string: "Copyright © 2019 Geektree0101",
            attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                         .foregroundColor: UIColor.lightGray])
    return label
  }()
  
  lazy var opticle = HistoryListOpticle.init()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    opticle.watch()
      .render({ [weak self] state in
        self?.tableView.reloadData()
      })
    
    self.opticle.dispatch(.reload)
  }
  
  @objc func didTapLoadMore() {
    
    opticle.dispatch(.loadMore)
  }
}

extension HistoryListController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return opticle.state.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let reuseCell = tableView
      .dequeueReusableCell(withIdentifier: HistoryListCell.Const.identifier, for: indexPath) as! HistoryListCell
    
    if opticle.state.items.count > indexPath.row {
      reuseCell.opticle = opticle.state.items[indexPath.row]
    }
    
    return reuseCell
  }
  
  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView,
                 viewForFooterInSection section: Int) -> UIView? {
    
    guard opticle.state.hasNextPage == true else {
      return loadEndedLabel
    }
    return loadMoreButton
  }
  
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    
    return 100.0
  }
  
  func tableView(_ tableView: UITableView,
                 heightForFooterInSection section: Int) -> CGFloat {
    
    return opticle.state.hasNextPage == true ? 60.0 : 20.0
  }
}

extension HistoryListController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    
    guard opticle.state.items.count > indexPath.row,
      let viewController = self.storyboard?
        .instantiateViewController(withIdentifier: "show") as? HistoryShowController else {
          return
    }
    
    let targetOpticle = opticle.state.items[indexPath.row]
    
    // NOTE: dataPassing
    viewController.opticle.state.history = targetOpticle.state.history
    
    viewController.opticle.watch().render({ state in
      
      switch state.status {
      case .edited:
        targetOpticle.dispatch(.updateTitle(state.title))
      default:
        break
      }
    })
    
    self.present(viewController, animated: true, completion: nil)
  }
}
