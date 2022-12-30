//
//  FavoritesInteractor.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
/////////////////////// FAVORITES INTERACTOR PROTOCOLS
protocol FavoritesInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: [Movie]?, error: Error?)
}

protocol FavoritesInteractorInputProtocol {
    var presenter: FavoritesInteractorOutputProtocol? { get set }
    func getMovies()
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// FAVORITES INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class FavoritesInteractor: FavoritesInteractorInputProtocol {
    
    weak var presenter: FavoritesInteractorOutputProtocol?
    
    func getMovies() {
        
        do {
            var favorites = [Movie]()
            
            let realm = RealmManager.shared
            favorites = realm.render()
            
            presenter?.interactorGetDataPresenter(receivedData: favorites, error: nil)
            
        } catch {
            presenter?.interactorGetDataPresenter(receivedData: nil, error: error)
        }
        
        
    }
    
}
