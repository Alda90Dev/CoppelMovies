//
//  ProfilePresenterInput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation

import Combine

struct ProfilePresenterInput {
    let loadMovies = PassthroughSubject<Void, Never>()
}
