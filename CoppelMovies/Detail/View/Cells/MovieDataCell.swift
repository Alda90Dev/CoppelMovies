//
//  MovieDataCell.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import UIKit

protocol ActionVideoButtonDelegate: AnyObject {
    func actionVideo()
}

class MovieDataCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MovieDataCell.self)
    weak var delegate: ActionVideoButtonDelegate?
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 35.0)
        return lbl
    }()
    
    private lazy var lblYear: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.padding(2, 2, 5, 5)
        return lbl
    }()
    
    private lazy var lblLanguage: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.padding(2, 2, 5, 5)
        return lbl
    }()
    
    private lazy var lblRating: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.padding(2, 2, 5, 5)
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()
    
    private lazy var lblGenres: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var lblOverview: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.textAlignment = .justified
        return lbl
    }()
    
    private lazy var btnVideos: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Content.btnVideos, for: .normal)
        btn.setTitleColor(ColorCatalog.principal, for: .normal)
        btn.layer.borderColor = ColorCatalog.principal.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(tappedAction), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movie: Movie, delegate: ActionVideoButtonDelegate) {
        lblTitle.text = movie.originalTitle
        lblYear.text = getYearString(dateString: movie.releaseDate) ?? ""
        lblLanguage.text = movie.originalLanguage
        lblRating.text = "\(Content.K.star) \(String(describing: movie.voteAverage ?? 0.0))"
        lblGenres.text = movie.getGenres()
        lblOverview.text = movie.overview
        self.delegate = delegate
    }
}

private extension MovieDataCell {
    func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        stackView.addArrangedSubview(lblYear)
        stackView.addArrangedSubview(lblLanguage)
        stackView.addArrangedSubview(lblRating)
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(stackView)
        contentView.addSubview(lblGenres)
        contentView.addSubview(btnVideos)
        contentView.addSubview(lblOverview)
        
        
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lblTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            stackView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            lblGenres.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            lblGenres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lblGenres.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            lblOverview.topAnchor.constraint(equalTo: lblGenres.bottomAnchor, constant: 16),
            lblOverview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lblOverview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            btnVideos.topAnchor.constraint(equalTo: lblOverview.bottomAnchor, constant: 45),
            btnVideos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            btnVideos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            btnVideos.heightAnchor.constraint(equalToConstant: 45),
            btnVideos.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            
        ])
    }
    
    func getYearString(dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return String(calendar.component(.year, from: dateFormatter.date(from: dateString) ?? Date()))
    }
    
    @objc func tappedAction() {
        delegate?.actionVideo()
    }
}
