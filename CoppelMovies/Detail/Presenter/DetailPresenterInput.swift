//
//  DetailPresenterInput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import Combine

struct DetailPresenterInput {
    let loadMovieDetail = PassthroughSubject<Void, Never>()
    let goToVideos = PassthroughSubject<Void, Never>()
    let setFavorite = PassthroughSubject<Bool, Never>()
}
