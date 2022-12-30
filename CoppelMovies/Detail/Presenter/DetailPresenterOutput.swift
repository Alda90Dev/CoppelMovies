//
//  DetailPresenterOutput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import Combine

struct DetailPresenterOutput {
    let initDataPublisher = PassthroughSubject<(Movie, [TypeDetailRow]), Never>()
    let detailDataPublisher = PassthroughSubject<Result<Movie, Error>, Never>()
    let resultFavoritePublisher = PassthroughSubject<Result<Bool, Error>, Never>()
}
