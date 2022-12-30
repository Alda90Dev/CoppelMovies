//
//  FavoritesPresenterInput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import Combine

struct FavoritesPresenterInput {
    let getMovies = PassthroughSubject<Void, Never>()
}
