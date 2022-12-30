//
//  LoginRouter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation
import UIKit

/////////////////////// LOGIN ROUTER  PROTOCOL
protocol LoginRouterProtocol {
    var presenter: LoginPresenterProtocol? { get set }
    static func createLoginModule() -> UIViewController
    func goToHome(from view: LoginViewProtocol)
}


////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// LOGIN ROUTER
///////////////////////////////////////////////////////////////////////////////////////////////////
class LoginRouter: LoginRouterProtocol {

    var presenter: LoginPresenterProtocol?
    
    static func createLoginModule() -> UIViewController {
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// MARK: I choose this implementation to create every class, but it can be improved
        /// with the builder patter, and adding dependecy injection when the instances are created.
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let view = LoginView()

        let interactor = LoginInteractor()
        let presenter: LoginPresenterProtocol & LoginInteractorOutputProtocol = LoginPresenter()
        let router = LoginRouter()

        router.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
    
    func goToHome(from view: LoginViewProtocol) {
        if let vc = view as? UIViewController {
            let homeView = HomeRouter.createHomeModule()
            let navVC = UINavigationController(rootViewController: homeView)
            navVC.modalPresentationStyle = .fullScreen
            vc.present(navVC, animated: true)
        }
    }
}
