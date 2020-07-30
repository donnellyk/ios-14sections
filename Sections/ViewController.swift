import UIKit

/// BOO, iOS 13 Necessity
struct SimpleCache {
  static var favorites: [String] = []
  static var other: [String] = []
}


class ViewController: UIViewController {
  enum Section {
    case favorites
    case other
  }
  
  var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    setupButton()
    setupLayout()
    setupDataSource()
    fetchAll()
  }
}

private extension ViewController {
  func setupButton() {
    let favAction = UIAction(title: "Refresh Favorite") { [weak self] _ in
      self?.fetchFavorites()
    }
    
    let otherAction = UIAction(title: "Refresh Other") { [weak self] _ in
      self?.fetchOther()
    }
    
    let allAction = UIAction(title: "Refresh All") { [weak self] _ in
      self?.fetchAll()
    }
    
    let menu = UIMenu(title: "", children: [favAction, otherAction, allAction])
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", primaryAction: favAction, menu: menu)
    
  }
  
  func setupLayout() {
    var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    config.headerMode = .firstItemInSection
      
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
  }
  
  func setupDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
      var content = cell.defaultContentConfiguration()
      content.text = item
      cell.contentConfiguration = content
    }
    
    dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, color: String) -> UICollectionViewCell? in
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: color)
    }
    
    collectionView.dataSource = dataSource
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.favorites, .other])
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func fetchAll() {
    fetchFavorites()
    fetchOther()
  }
  
  func fetchFavorites() {
    API.fetchFavorites { [weak self] in
      guard let self = self else { return }
      
      let withHeader = ["Favorite Colors"] + $0
      
      /// Yay, iOS 14 version
//      var section = NSDiffableDataSourceSectionSnapshot<String>()
//      section.append(withHeader)
//      self.dataSource.apply(section, to: .favorites, animatingDifferences: true, completion: nil)
      
      
      /// **Boo, iOS 13 Implementation**
      SimpleCache.favorites = withHeader
      var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
      snapshot.appendSections([.favorites, .other])
      
      snapshot.appendItems(SimpleCache.favorites, toSection: .favorites)
      snapshot.appendItems(SimpleCache.other, toSection: .other)
      
      self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
  }
  
  func fetchOther() {
    API.fetchOther { [weak self] in
      guard let self = self else { return }
      
      let withHeader = ["Other Colors"] + $0
      
      /// Yay, iOS 14 version
//      var section = NSDiffableDataSourceSectionSnapshot<String>()
//      section.append(withHeader)
//      self.dataSource.apply(section, to: .other, animatingDifferences: true, completion: nil)
      

      /// **Boo, iOS 13 Implementation**
      SimpleCache.other = withHeader
      var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
      snapshot.appendSections([.favorites, .other])
      
      snapshot.appendItems(SimpleCache.favorites, toSection: .favorites)
      snapshot.appendItems(SimpleCache.other, toSection: .other)
      
      self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
  }
}

