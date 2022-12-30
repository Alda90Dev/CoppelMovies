//
//  LoginPresenter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation
import Combine

/////////////////////// LOGIN PRESENTER PROTOCOL
protocol LoginPresenterProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func bind(input: LoginPresenterInput) -> LoginPresenterOutput
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// LOGIN PRESENTER
///////////////////////////////////////////////////////////////////////////////////////////////////

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var router: LoginRouterProtocol?
    var output: LoginPresenterOutput = LoginPresenterOutput()
    
    private var subscriptions = Set<AnyCancellable>()
    

    func bind(input: LoginPresenterInput) -> LoginPresenterOutput {
        input.tapToLogin.sink { [weak self] (user, password) in
           
            self?.interactor?.login(user: user, password: password)
        }.store(in: &self.subscriptions)
        
        return output
    }
}

extension LoginPresenter: LoginInteractorOutputProtocol {
    
    func interactorGetDataPresenter(receivedData: TokenResponse?, error: Error?) {
        if let error = error {
            output.loginDataErrorPublisher.send(error)
        } else {
            if let response = receivedData,
               response.success {
                output.loginDataErrorPublisher.send(nil)
                router?.goToHome(from: view!)
            }
        }
    }
    
}
