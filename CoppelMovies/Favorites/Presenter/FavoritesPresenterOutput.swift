//
//  FavoritesPresenterOutput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import Combine

struct FavoritesPresenterOutput {
    let favoritesDataPublisher = PassthroughSubject<Result<[Movie], Error>, Never>()
}
