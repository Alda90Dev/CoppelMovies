//
//  ImageCell.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import UIKit
import SDWebImage

class ImageCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ImageCell.self)
    
    let posterImage = UIImageView()
    
    var posterPathURL: URL? {
        didSet {
            configure()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ImageCell {
    func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(posterImage)
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.contentMode = .scaleToFill
        posterImage.backgroundColor = .clear
        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure() {
        if let url = posterPathURL {
            posterImage.sd_setImage(with: url)
        }
    }
}
