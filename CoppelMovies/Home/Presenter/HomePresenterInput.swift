//
//  HomePresenterInput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import Combine

struct HomePresenterInput {
    let getMovies = PassthroughSubject<(Int, Bool), Never>()
    let goToMovieDetail = PassthroughSubject<Movie, Never>()
    let goToProfile = PassthroughSubject<Void, Never>()
    let logOut = PassthroughSubject<Void, Never>()
}
