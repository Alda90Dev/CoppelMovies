//
//  ProductionCell.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import UIKit

class ProductionCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ProductionCell.self)
    
    private lazy var lblProduction: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = ColorCatalog.principal
        lbl.text = Content.productions
        lbl.font = UIFont.systemFont(ofSize: 12.0)
        return lbl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var collectionAdapter: ComposableSection = {
        let adapter = ComposableSection(collectionView: collectionView, viewController: nil, sectionType: .productions)
        return adapter
    }()
    
    private var viewController: UIViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(productions: [ProductionCompanies]?) {
        
        collectionAdapter.setupCollectionView()
        if let productions = productions {
            collectionAdapter.updateSnapshotProductions(productions: productions)
        }
    }
}


private extension ProductionCell {
    
    func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(lblProduction)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            lblProduction.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            lblProduction.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lblProduction.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: lblProduction.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
    }
}
