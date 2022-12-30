//
//  HomePresenterOutput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import Combine

struct HomePresenterOutput {
    let homeDataPublisher = PassthroughSubject<Result<[Movie], Error>, Never>()
}
