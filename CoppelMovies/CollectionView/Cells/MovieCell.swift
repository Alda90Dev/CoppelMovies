//
//  MovieCell.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MovieCell.self)
    private let cache = NSCache<NSString, UIImage>()
    
    private lazy var posterImage: UIImageView = {
        let image  = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = false
        return image
    }()
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = ColorCatalog.principal
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private lazy var lblReleaseDate: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = ColorCatalog.principal
        lbl.font = UIFont.boldSystemFont(ofSize: 12.0)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private lazy var lblRating: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = ColorCatalog.principal
        lbl.font = UIFont.boldSystemFont(ofSize: 12.0)
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()
    
    private lazy var lblOverview: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 10.0)
        lbl.numberOfLines = 4
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private var id: String?

    var posterPathURL: URL? {
        didSet {
            setupImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movie: Movie) {
        id = String(describing: movie.id)
        posterPathURL = movie.posterPathURL()
        lblTitle.text = movie.originalTitle ?? ""
        lblReleaseDate.text = movie.formattedReleasedDate()
        let star = Content.K.star
        lblRating.text = "\(star) \(String(describing: movie.voteAverage ?? 0.0))"
        lblOverview.text = movie.overview
    }
}

private extension MovieCell {
    func setupView() {
        contentView.addSubview(posterImage)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblReleaseDate)
        contentView.addSubview(lblRating)
        contentView.addSubview(lblOverview)
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = ColorCatalog.backgroundSplash
        
        let viewHeight = self.bounds.height

        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImage.heightAnchor.constraint(equalToConstant: viewHeight - (viewHeight / 3)),
            
            lblTitle.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 8),
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lblTitle.heightAnchor.constraint(equalToConstant: 25),
            
            lblReleaseDate.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            lblReleaseDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblReleaseDate.trailingAnchor.constraint(equalTo: lblRating.leadingAnchor, constant: 4),
            lblReleaseDate.heightAnchor.constraint(equalToConstant: 15),
            
            lblRating.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            lblRating.leadingAnchor.constraint(equalTo: lblReleaseDate.trailingAnchor, constant: 4),
            lblRating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lblRating.widthAnchor.constraint(equalToConstant: 50),
            lblRating.heightAnchor.constraint(equalToConstant: 15),
            
            lblOverview.topAnchor.constraint(equalTo: lblReleaseDate.bottomAnchor, constant: 8),
            lblOverview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblOverview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lblOverview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func setupImage() {
        if let cacheImage = cache.object(forKey: NSString(string: id ?? Content.K.image)) {
            posterImage.image = cacheImage
        } else {
            if let url = posterPathURL {
                posterImage.sd_setImage(with: url, placeholderImage: ImageCatalog.logo) { [weak self] image, error, _, _ in
                    guard let self = self else { return }
                    if let image = image {
                        self.posterImage.image = image
                        self.cache.setObject(image, forKey: NSString(string: self.id ?? Content.K.image))
                    }
                }
            }
        }
    }
}
