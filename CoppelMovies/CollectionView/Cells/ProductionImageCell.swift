//
//  ProductionImageCell.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import UIKit
import SDWebImage

class ProductionImageCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ProductionImageCell.self)
    
    let logoImage = UIImageView()
    
    var logoPathURL: URL? {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProductionImageCell {
    func setupView() {
        backgroundColor = .clear
        contentView.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.contentMode = .scaleToFill
        logoImage.backgroundColor = .clear
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            logoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure() {
        if let url = logoPathURL {
            logoImage.sd_setImage(with: url)
        }
    }
}
