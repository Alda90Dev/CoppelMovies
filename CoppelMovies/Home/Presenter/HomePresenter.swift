//
//  HomePresenter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import Combine

/////////////////////// HOME PRESENTER PROTOCOL
protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    var isPaginating: Bool { get set }
    var pagination: Bool { get set }
    
    func bind(input: HomePresenterInput) -> HomePresenterOutput
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME PRESENTER
///////////////////////////////////////////////////////////////////////////////////////////////////

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var router: HomeRouterProtocol?
    var output: HomePresenterOutput = HomePresenterOutput()
    var isPaginating: Bool = false
    var pagination: Bool = false
    private var movies = [Movie]()
    private var page = 1
    
    private var subscriptions = Set<AnyCancellable>()
    
    func bind(input: HomePresenterInput) -> HomePresenterOutput {
        input.getMovies.sink { [weak self] load in
            self?.pagination = load.1
            self?.getMovies(index: load.0)
        }.store(in: &self.subscriptions)
        
        input.goToMovieDetail.sink { [weak self] movie in
            guard let self = self else { return }
            self.router?.goToDetail(from: self.view!, movie: movie)
        }.store(in: &self.subscriptions)
        
        input.goToFavorites.sink { [weak self] in
            guard let self = self else { return }
            self.router?.goToFavorites(from: self.view!)
        }.store(in: &self.subscriptions)
        
        input.goToProfile.sink { [weak self] in
            self?.goToProfile()
        }.store(in: &self.subscriptions)
        
        input.logOut.sink { [weak self] in
            self?.logOut()
        }.store(in: &self.subscriptions)
        
        return output
    }
    
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
    func getMovies(index: Int) {
        if pagination {
            page += 1
            isPaginating = true
        } else {
            page = 1
        }
        let pageString = String(describing: page)
        
        switch index {
        case 0:
            interactor?.getMovies(typeService: .getPopular(page: pageString))
        case 1:
            interactor?.getMovies(typeService: .getTopRated(page: pageString))
        case 2:
            interactor?.getMovies(typeService: .getUpcomings(page: pageString))
        case 3:
            interactor?.getMovies(typeService: .getNowPlaying(page: pageString))
        default:
            break
        }
        
    }
    
    func interactorGetDataPresenter(receivedData: MovieResponse?, error: Error?) {
        isPaginating = false
        if !pagination {
            movies = []
        }
        if let error = error {
            output.homeDataPublisher.send(.failure(error))
        } else if let data = receivedData {
            movies.append(contentsOf: data.movies)
            output.homeDataPublisher.send(.success(movies))
        }
    }
    
    func goToProfile() {
        router?.goToProfile(from: view!)
    }
    
    func logOut() {
        removeFromKeychain()
        Defaults.shared.user = ""
        Defaults.shared.name = ""
        Defaults.shared.avatar = ""
        Defaults.shared.account = 0
        router?.logOut(from: view!)
    }
    
    private func removeFromKeychain() {
        do {
            try KeychainManager.remove(service: NetworkRouter.service, account: Defaults.shared.user)
        } catch {
            print(error)
        }
    }
}
