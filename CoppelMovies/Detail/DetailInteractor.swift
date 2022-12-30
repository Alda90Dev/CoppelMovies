//
//  DetailInteractor.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation

/////////////////////// DETAIL INTERACTOR PROTOCOLS
protocol DetailInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: Movie?, error: Error?)
    func interactorGetFavoriteResult(error: Error?)
}

protocol DetailInteractorInputProtocol {
    var presenter: DetailInteractorOutputProtocol? { get set }
    func getMovieDetail(id: Int)
    func setFavorite(isFavorite: Bool, movie: Movie)
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DETAIL INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class DetailInteractor: DetailInteractorInputProtocol {
    
    weak var presenter: DetailInteractorOutputProtocol?
    
    func getMovieDetail(id: Int) {
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.getMovieDetail(id: id)) { [weak self] (result: NetworkResult<Movie>) in
            switch result {
            case .success(let response):
                self?.presenter?.interactorGetDataPresenter(receivedData: response, error: nil)
                break
            case .failure(error: let error):
                self?.presenter?.interactorGetDataPresenter(receivedData: nil, error: error)
            }
        }
        
    }
    
    func setFavorite(isFavorite: Bool, movie: Movie) {
        do {
            let realm = RealmManager.shared
            
            if isFavorite {
                realm.save(movie: movie)
            } else {
                realm.delete(movie: movie)
            }
            
            presenter?.interactorGetFavoriteResult(error: nil)
        } catch {
            presenter?.interactorGetFavoriteResult(error: error)
        }
        
    }
    
}
