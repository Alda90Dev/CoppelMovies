//
//  ComposableSectionOutput.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import Combine

struct ComposableSectionOutput {
    let callToAction = PassthroughSubject<Movie, Never>()
    let fetchData = PassthroughSubject<Void, Never>()
}
