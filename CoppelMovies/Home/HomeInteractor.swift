//
//  HomeInteractor.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation

/////////////////////// HOME INTERACTOR PROTOCOLS
protocol HomeInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: MovieResponse?, error: Error?)
}

protocol HomeInteractorInputProtocol {
    var presenter: HomeInteractorOutputProtocol? { get set }
    func getMovies(typeService: NetworkRouter)
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class HomeInteractor: HomeInteractorInputProtocol {
    
    weak var presenter: HomeInteractorOutputProtocol?
    
    func getMovies(typeService: NetworkRouter) {
        
        NetworkManager.shared.request(networkRouter: typeService) { [weak self] (result: NetworkResult<MovieResponse>) in
            switch result {
            case .success(let response):
                self?.presenter?.interactorGetDataPresenter(receivedData: response, error: nil)
                break
            case .failure(error: let error):
                self?.presenter?.interactorGetDataPresenter(receivedData: nil, error: error)
            }
        }
        
    }
    
}
