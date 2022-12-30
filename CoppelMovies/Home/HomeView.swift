//
//  HomeView.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import UIKit
import Combine

/////////////////////// HOME VIEW PROTOCOL
protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////
class HomeView: UIViewController {
    var presenter: HomePresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private let presenterInput: HomePresenterInput = HomePresenterInput()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentItems = [
            Content.Segment.popular,
            Content.Segment.topRated,
            Content.Segment.upcoming,
            Content.Segment.nowPlaying
        ]
        let segmented = UISegmentedControl(items: segmentItems)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmented.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmented.selectedSegmentTintColor = ColorCatalog.placeholder
        segmented.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        return segmented
    }()
    
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
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()

    private let spinner = UIActivityIndicatorView()
    private let appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        segmentedControl.selectedSegmentIndex = 0
        getMovies(index: 0, paginate: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appearance.backgroundColor = ColorCatalog.backgroundSplash
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}
private extension HomeView {
    
    func getMovies(index: Int, paginate: Bool) {
        presenterInput.getMovies.send((index, paginate))
    }
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        let outputAdapter = collectionAdapter.bind()
        
        output?.homeDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.spinner.stopAnimating()
                switch result {
                case .success(let data):
                    if !(self?.presenter?.pagination ?? false) {
                        self?.collectionView.setContentOffset(.zero, animated: false)
                    }
                    self?.collectionAdapter.updateSnapshot(movies: data)
                    break
                case .failure(let error):
                    self?.presentAlert(Content.errorMessage, message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
        
        outputAdapter.callToAction
            .sink { [weak self] movie in
                self?.presenterInput.goToMovieDetail.send(movie)
            }
            .store(in: &subscriptions)
        
        outputAdapter.fetchData
            .sink { [weak self] in
                guard let self = self else { return }
                if let presenter = self.presenter,
                   !presenter.isPaginating {
                    self.spinner.startAnimating()
                    let index = self.segmentedControl.selectedSegmentIndex
                    self.getMovies(index: index, paginate: true)
                }
        }.store(in: &self.subscriptions)
    }
    
    func setupView() {
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.backgroundColor = ColorCatalog.background
        title = Content.moviesTitle
        
        let barButtonItem = UIBarButtonItem(image: ImageCatalog.iconMenu, style: .plain, target: self, action: #selector(didTapMenu))
        navigationItem.rightBarButtonItem = barButtonItem
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(footerView)
        view.bringSubviewToFront(footerView)
        NSLayoutConstraint.activate([
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            footerView.heightAnchor.constraint(equalToConstant: 44),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        collectionAdapter.setupCollectionView()
    }
    
    @objc func didTapMenu() {
        showSimpleActionSheet(controller: self)
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        getMovies(index: segmentedControl.selectedSegmentIndex, paginate: false)
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
    

    func showSimpleActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "", message: Content.alert.alertMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Content.alert.viewProfile, style: .default, handler: { [weak self] (_) in
            self?.presenterInput.goToProfile.send()
        }))
        
        alert.addAction(UIAlertAction(title: Content.alert.viewFavorites, style: .default, handler: { [weak self] (_) in
            self?.presenterInput.goToFavorites.send()
        }))

        alert.addAction(UIAlertAction(title: Content.alert.logOut, style: .destructive, handler: { [weak self] (_) in
            self?.presenterInput.logOut.send()
        }))

        alert.addAction(UIAlertAction(title: Content.alert.cancel, style: .cancel, handler: { (_) in
            debugPrint("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            debugPrint("completion block")
        })
    }
}

extension FavoritesView: FavoritesViewProtocol { }
