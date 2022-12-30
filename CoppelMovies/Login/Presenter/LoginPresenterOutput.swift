//
//  LoginPresenterOuput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation
import Combine

struct LoginPresenterOutput {
    let loginDataErrorPublisher = PassthroughSubject<Error?, Never>()
}
