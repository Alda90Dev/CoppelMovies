//
//  ComposableSection.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import UIKit
import Combine

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// MARK:  This distribution is clearer to read than having an only file the
/// composablecollectionview. But also this could be better with a generics implementation.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public class ComposableSection: NSObject {
    
    public enum Section: CaseIterable {
        case grid
        case horizontal
        case productions
    }
    
    internal var collectionView: UICollectionView
    internal var viewController: UIViewController?
    internal var sectionType: Section
    
    internal static let sectionFooterElementKind = "section-footer-element-kind"
    
    internal var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private var subscriptions = Set<AnyCancellable>()
    
    var output: ComposableSectionOutput = ComposableSectionOutput()
    
    public init(collectionView: UICollectionView, viewController: UIViewController?, sectionType: Section) {
        self.collectionView = collectionView
        self.viewController = viewController
        self.sectionType = sectionType
        super.init()
    }
    
    func setupCollectionView() {
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.register(ProductionImageCell.self, forCellWithReuseIdentifier: ProductionImageCell.reuseIdentifier)
        collectionView.delegate = self
    }
    
    func bind() -> ComposableSectionOutput {
        return output
    }

    func updateSnapshot(movies: [Movie]) {
        configureDataSource()
        let snapshot = snapshotForCurrentState(movies)
        if let dataSource = self.dataSource {
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func updateSnapshotProductions(productions: [ProductionCompanies]) {
        configureDataSource()
        let snapshot = snapshotProductionsForCurrentState(productions)
        if let dataSource = self.dataSource {
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
}
