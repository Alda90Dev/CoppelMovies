//
//  DetailRouter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import UIKit

/////////////////////// DETAIL ROUTER  PROTOCOL
protocol DetailRouterProtocol {
    var presenter: DetailPresenterProtocol? { get set }
    static func createDetailModule(movie: Movie) -> UIViewController
    func goToVideos(from view: DetailViewProtocol, id: Int)
}


////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DETAIL ROUTER
///////////////////////////////////////////////////////////////////////////////////////////////////
class DetailRouter: DetailRouterProtocol {
    
    var presenter: DetailPresenterProtocol?
    
    static func createDetailModule(movie: Movie) -> UIViewController {
        
        let view = DetailView()

        let interactor = DetailInteractor()
        let presenter: DetailPresenterProtocol & DetailInteractorOutputProtocol = DetailPresenter()
        let router = DetailRouter()

        router.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.movie = movie
        view.presenter = presenter
        presenter.view = view
        
        return view
    }

    func goToVideos(from view: DetailViewProtocol, id: Int) {
        if let vc = view as? UIViewController {
            let videosView = VideosRouter.createVideosModule(id: id)
            vc.present(videosView, animated: true)
        }
    }
}
