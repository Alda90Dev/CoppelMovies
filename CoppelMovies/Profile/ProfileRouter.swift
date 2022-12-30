//
//  ProfileRouter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import UIKit

/////////////////////// PROFILE ROUTER  PROTOCOL
protocol ProfileRouterProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
    static func createProfileModule() -> UIViewController
}


////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// PROFILE ROUTER
///////////////////////////////////////////////////////////////////////////////////////////////////
class ProfileRouter: ProfileRouterProtocol {

    var presenter: ProfilePresenterProtocol?
    
    static func createProfileModule() -> UIViewController {
        
        let view = ProfileView()

        let interactor = ProfileInteractor()
        let presenter: ProfilePresenterProtocol & ProfileInteractorOutputProtocol = ProfilePresenter()
        let router = ProfileRouter()

        router.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
   
}
