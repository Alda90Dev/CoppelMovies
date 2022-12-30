//
//  HomeRouter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import UIKit

/////////////////////// HOME ROUTER  PROTOCOL
protocol HomeRouterProtocol {
    var presenter: HomePresenterProtocol? { get set }
    static func createHomeModule() -> UIViewController
    func goToDetail(from view: HomeViewProtocol, movie: Movie)
    func goToProfile(from view: HomeViewProtocol)
    func goToFavorites(from view: HomeViewProtocol)
    func logOut(from view: HomeViewProtocol)
}


////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME ROUTER
///////////////////////////////////////////////////////////////////////////////////////////////////
class HomeRouter: HomeRouterProtocol {
    
    var presenter: HomePresenterProtocol?
    
    static func createHomeModule() -> UIViewController {
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// MARK: I choose this implementation to create every class, but it can be improved
        /// with the builder patter, and adding dependecy injection when the instances are created.
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let view = HomeView()

        let interactor = HomeInteractor()
        let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
        let router = HomeRouter()

        router.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
    
    func goToDetail(from view: HomeViewProtocol, movie: Movie) {
        let detailView = DetailRouter.createDetailModule(movie: movie)
        
        if let vc = view as? UIViewController {
            vc.navigationController?.pushViewController(detailView, animated: false)
        }
        
    }
    
    func goToFavorites(from view: HomeViewProtocol) {
        let favoritesView = FavoritesRouter.createFavoritesModule()
        
        if let vc = view as? UIViewController {
            vc.navigationController?.pushViewController(favoritesView, animated: true)
        }
    }
    
    func goToProfile(from view: HomeViewProtocol) {
       
    }
    
    func logOut(from view: HomeViewProtocol) {
        
    }
}
