//
//  ProfilePresenterOutput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import Combine

struct ProfilePresenterOutput {
    let profileDataPublisher = PassthroughSubject<Result<[Movie], Error>, Never>()
}
