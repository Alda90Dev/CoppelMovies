//
//  LoginPresenterInput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation
import Combine

struct LoginPresenterInput {
    let tapToLogin = PassthroughSubject<(String, String), Never>()
}
