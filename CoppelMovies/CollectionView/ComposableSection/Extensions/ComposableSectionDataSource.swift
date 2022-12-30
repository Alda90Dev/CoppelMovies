//
//  ComposableSectionDataSource.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import UIKit

// MARK: DataSource
internal extension ComposableSection {

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Section, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, movieItem: AnyHashable) -> UICollectionViewCell? in
                
            let sectionType = self.sectionType
            switch sectionType {
            case .grid, .horizontal:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieCell.reuseIdentifier,
                    for: indexPath) as? MovieCell else { fatalError("Could not create new cell") }
                let item = movieItem as! Movie
                cell.configure(movie: item)
                return cell
            case .productions:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductionImageCell.reuseIdentifier,
                    for: indexPath) as? ProductionImageCell else { fatalError("Could not create new cell") }
                let item = movieItem as! ProductionCompanies
                cell.logoPathURL = item.logoPathURL()
                return cell
            }
        }
        
    }
        
    func snapshotForCurrentState(_ movies: [Movie]) -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([sectionType])
        snapshot.appendItems(movies)
            
        return snapshot
    }
    
    func snapshotProductionsForCurrentState(_ productions: [ProductionCompanies]) -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([sectionType])
        snapshot.appendItems(productions)
            
        return snapshot
    }
    
}
