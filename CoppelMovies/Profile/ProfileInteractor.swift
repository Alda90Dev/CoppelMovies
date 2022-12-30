//
//  ProfileInteractor.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation

/////////////////////// PROFILE INTERACTOR PROTOCOLS
protocol ProfileInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: [Movie]?, error: Error?)
}

protocol ProfileInteractorInputProtocol {
    var presenter: ProfileInteractorOutputProtocol? { get set }
    func getMovies()
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// PROFILE INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class ProfileInteractor: ProfileInteractorInputProtocol {
    
    weak var presenter: ProfileInteractorOutputProtocol?
    
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
