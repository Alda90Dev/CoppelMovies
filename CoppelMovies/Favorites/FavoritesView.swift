//
//  FavoritesView.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import UIKit
import Combine

/////////////////////// FAVORITES VIEW PROTOCOL
protocol FavoritesViewProtocol: AnyObject {
    var presenter: FavoritesPresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// FAVORITES VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////
class FavoritesView: UIViewController {
    var presenter: FavoritesPresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private let presenterInput: FavoritesPresenterInput = FavoritesPresenterInput()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var collectionAdapter: ComposableSection = {
        let adapter = ComposableSection(collectionView: collectionView, viewController: self, sectionType: .grid)
        return adapter
    }()

    private let spinner = UIActivityIndicatorView()
    private let appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        presenterInput.getMovies.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appearance.backgroundColor = ColorCatalog.backgroundSplash
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}
private extension FavoritesView {
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        
        output?.favoritesDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.spinner.stopAnimating()
                switch result {
                case .success(let data):
                    self?.collectionAdapter.updateSnapshot(movies: data)
                    break
                case .failure(let error):
                    self?.presentAlert(Content.errorMessage, message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
    }
    
    func setupView() {
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.backgroundColor = ColorCatalog.background
        title = Content.favoritesTitle
    
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
        ])
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

extension HomeView: HomeViewProtocol { }
