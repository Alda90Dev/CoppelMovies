//
//  SplashRouter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation
import UIKit

/////////////////////// SPLASH ROUTER  PROTOCOL
protocol SplashRouterProtocol {
    static func createSplashModule() -> UIViewController
    func goTo(from view: SplashViewProtocol)
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// SPLASH ROUTER
///////////////////////////////////////////////////////////////////////////////////////////////////
///

class SplashRouter: SplashRouterProtocol {
    
    static func createSplashModule() -> UIViewController {
        
        let view = SplashView()
        let presenter: SplashPresenterProtocol = SplashPresenter()
        let router = SplashRouter()
        
        presenter.router = router
        view.presenter = presenter
        presenter.view = view

        return view
    }
    
    func goTo(from view: SplashViewProtocol) {
        validateUser(from: view)
    }
}

private extension SplashRouter {
    
    func validateUser(from view: SplashViewProtocol) {
        debugPrint( Defaults.shared.user)
        Defaults.shared.user.isEmpty ? goToLogin(from: view) : goToHome(from: view)
    }

    func goToLogin(from view: SplashViewProtocol) {
        if let vc = view as? UIViewController {
            let homeView = LoginRouter.createLoginModule()
            homeView.modalTransitionStyle = .crossDissolve
            homeView.modalPresentationStyle = .fullScreen
            vc.present(homeView, animated: true)
        }
    }
    
    func goToHome(from view: SplashViewProtocol) {
        if let vc = view as? UIViewController {
            let homeView = HomeRouter.createHomeModule()
            let navVC = UINavigationController(rootViewController: homeView)
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen
            vc.present(navVC, animated: true)
        }
    }
    
}
