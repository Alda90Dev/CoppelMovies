//
//  FavoritesPresenter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import Combine

/////////////////////// FAVORITES PRESENTER PROTOCOL
protocol FavoritesPresenterProtocol: AnyObject {
    var view: FavoritesViewProtocol? { get set }
    var interactor: FavoritesInteractorInputProtocol? { get set }
    var router: FavoritesRouterProtocol? { get set }
    
    func bind(input: FavoritesPresenterInput) -> FavoritesPresenterOutput
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// FAVORITES PRESENTER
///////////////////////////////////////////////////////////////////////////////////////////////////

class FavoritesPresenter: FavoritesPresenterProtocol {
    
    weak var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorInputProtocol?
    var router: FavoritesRouterProtocol?
    var output: FavoritesPresenterOutput = FavoritesPresenterOutput()
    
    private var movies = [Movie]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    func bind(input: FavoritesPresenterInput) -> FavoritesPresenterOutput {
        input.getMovies.sink { [weak self] in
            self?.interactor?.getMovies()
        }.store(in: &self.subscriptions)
        
       
        return output
    }
    
}

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    
    func interactorGetDataPresenter(receivedData: [Movie]?, error: Error?) {
        if let error = error {
            output.favoritesDataPublisher.send(.failure(error))
        } else if let data = receivedData {
            output.favoritesDataPublisher.send(.success(data))
        }
    }
}
