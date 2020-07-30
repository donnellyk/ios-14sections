# Sections in iOS 14
### NSCoder July 2020 Talk

Highlights a thing iOS 14 makes slightly easier. So good of you, iOS 14.

### Sections
In iOS 13, to create a new snapshot, you had to know the complete state of your data. In cases where you only need to update a single section, this led to the need for a seperate source of truth. In many cases, a seperate source of truth is necessary and even preferred. But in simple cases, especially when the data isn't mutated directly (ie. only updated from an API), that can feel excessive:

```swift
SimpleCache.favorites = newFavorites
var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
snapshot.appendSections([.favorites, .other])

snapshot.appendItems(SimpleCache.favorites, toSection: .favorites)
snapshot.appendItems(SimpleCache.other, toSection: .other)

self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
```

In iOS 14, you can create a snapshop of a single section. In some cases, this will allow you to let the data source itself be your source of truth and you don't need a seperate cache.

```swift
var section = NSDiffableDataSourceSectionSnapshot<String>()
section.append(newFavorites)
self.dataSource.apply(section, to: .favorites, animatingDifferences: true, completion: nil)
```

### Erstwhile...
This project also uses a couple more iOS 14 tricks: `UIMenu` on a bar button item, `UIAction` instead of selectors, List layout in a `UICollectionView`, `config.headerMode = .firstItemInSection` if you are lazy and don't want to deal with supplemental views for headers