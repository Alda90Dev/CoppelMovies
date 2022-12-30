//
//  FavoritesRouter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import UIKit

/////////////////////// FAVORITES ROUTER  PROTOCOL
protocol FavoritesRouterProtocol {
    var presenter: FavoritesPresenterProtocol? { get set }
    static func createFavoritesModule() -> UIViewController
}


////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// FAVORITES ROUTER
///////////////////////////////////////////////////////////////////////////////////////////////////
class FavoritesRouter: FavoritesRouterProtocol {
    
    var presenter: FavoritesPresenterProtocol?
    
    static func createFavoritesModule() -> UIViewController {
        let view = FavoritesView()

        let interactor = FavoritesInteractor()
        let presenter: FavoritesPresenterProtocol & FavoritesInteractorOutputProtocol = FavoritesPresenter()
        let router = FavoritesRouter()

        router.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
    
}
