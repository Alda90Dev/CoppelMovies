//
//  DetailView.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import UIKit
import Combine

/////////////////////// DETAIL VIEW PROTOCOL
protocol DetailViewProtocol: AnyObject {
    var presenter: DetailPresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DETAIL VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////
class DetailView: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView =  UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentifier)
        tableView.register(MovieDataCell.self, forCellReuseIdentifier: MovieDataCell.reuseIdentifier)
        tableView.register(ProductionCell.self, forCellReuseIdentifier: ProductionCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var presenter: DetailPresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private let presenterInput: DetailPresenterInput = DetailPresenterInput()
    private let appearance = UINavigationBarAppearance()
    
    private var movie: Movie?
    private var rows: [TypeDetailRow]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        movie = presenter?.movie
        presenterInput.loadMovieDetail.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appearance.backgroundColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = nil
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

}
private extension DetailView {
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        
        output?.initDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.movie = result.0
                self?.rows = result.1
                self?.tableView.reloadData()
            }).store(in: &subscriptions)
        
        output?.detailDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                
                switch result {
                case .success(let data):
                    self?.movie = data
                    self?.tableView.reloadData()
                    break
                case .failure(let error):
                    self?.presentAlert(Content.errorMessage, message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
        
        output?.resultFavoritePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.updateTabBarIcons()
                case .failure(let error):
                    self?.presentAlert(Content.errorMessage, message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
    }
    
    func setupView() {
        view.backgroundColor = ColorCatalog.background
        view.addSubview(tableView)
        updateTabBarIcons()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    @objc func didFavorite() {
        guard let movieFav = movie else { return }
        
        let isFavorite = !(movieFav.isFavorite ?? false)
        movie?.isFavorite = isFavorite
        presenterInput.setFavorite.send(isFavorite)
    }
    
    func updateTabBarIcons() {
        var image: UIImage
        if let movie = movie,
           let isFavorite = movie.isFavorite {
            
            image = isFavorite ? ImageCatalog.iconHeartFilled : ImageCatalog.iconHeart
        } else {
            image = ImageCatalog.iconHeart
        }
        
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didFavorite))
        navigationItem.rightBarButtonItem = barButtonItem
    }
}

extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = rows else { return 0 }
        
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let rows = rows else { return UITableViewCell() }
        guard let movie = movie else { return UITableViewCell() }
        
        switch rows[indexPath.row] {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
            cell.posterPathURL = movie.backdropPathURL()
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDataCell.reuseIdentifier, for: indexPath) as! MovieDataCell
            cell.configure(movie: movie, delegate: self)
            return cell
        case .productions:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductionCell.reuseIdentifier, for: indexPath) as! ProductionCell
            cell.configure(productions: movie.productionCompanies)
            return cell
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
        
    }
}

extension DetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let rows = rows else {
            return UITableView.automaticDimension
        }
        
        switch rows[indexPath.row] {
        case .image:
            return 350
        case .productions:
            return 85
        case .space:
            return 45
        default:
            return UITableView.automaticDimension
        }
    }
}


extension DetailView: DetailViewProtocol { }

extension DetailView: ActionVideoButtonDelegate {
    func actionVideo() {
        presenterInput.goToVideos.send()
    }
}
