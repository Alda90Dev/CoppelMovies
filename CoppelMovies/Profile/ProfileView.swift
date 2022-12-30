//
//  ProfileView.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import UIKit
import Combine

/////////////////////// HOME VIEW PROTOCOL
protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////

class ProfileView: UIViewController {
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = ColorCatalog.principal
        lbl.font = UIFont.boldSystemFont(ofSize: 24.0)
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        lbl.text = Content.profileTitle
        return lbl
    }()
    
    private lazy var lblTitleShows: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = ColorCatalog.principal
        lbl.font = UIFont.boldSystemFont(ofSize: 20.0)
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        lbl.text = Content.favoritesTitle
        return lbl
    }()
    
    private lazy var profileImage: UIImageView = {
        let image  = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        
        return image
    }()
    
    private lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.font = UIFont.boldSystemFont(ofSize: 18.0)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private lazy var lblUser: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = ColorCatalog.principal
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private lazy var lblStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.spacing = 2
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var collectionAdapter: ComposableSection = {
        let adapter = ComposableSection(collectionView: collectionView, viewController: self, sectionType: .horizontal)
        return adapter
    }()
    
    var presenter: ProfilePresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private let presenterInput: ProfilePresenterInput = ProfilePresenterInput()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
        presenterInput.loadMovies.send()
    }
    
}

private extension ProfileView {
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        
        output?.profileDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
                    debugPrint(data)
                    self?.collectionAdapter.updateSnapshot(movies: data)
                    break
                case .failure(let error):
                    self?.presentAlert(Content.errorMessage, message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
    }
    
    func setupView() {
        view.backgroundColor = ColorCatalog.background
        
        lblStackView.addArrangedSubview(lblName)
        lblStackView.addArrangedSubview(lblUser)
      
        lblName.text = Defaults.shared.name
        lblUser.text = Defaults.shared.user
        
        let urlString = "\(Movie.baseURLImageString)\(Defaults.shared.avatar)"
        if let url = URL(string: urlString) {
            profileImage.sd_setImage(with: url)
        }
        
        view.addSubview(lblTitle)
        view.addSubview(lblTitleShows)
        view.addSubview(profileImage)
        view.addSubview(lblStackView)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            profileImage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 35),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 120),
            profileImage.widthAnchor.constraint(equalToConstant: 120),

            lblStackView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 72),
            lblStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            lblStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            lblTitleShows.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 35),
            lblTitleShows.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lblTitleShows.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: lblTitleShows.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        collectionAdapter.setupCollectionView()
    }
    
    func presentAlert(_ title: String, message: String) {
        self.openAlert(title: title,
                       message: message,
                       alertStyle: .alert,
                       actionTitles: [Content.alert.okMessage],
                       actionStyles: [.default],
                       actions: [ {_ in
            print(Content.alert.okMessage)
        },])
    }
    

}

extension ProfileView: ProfileViewProtocol { }
