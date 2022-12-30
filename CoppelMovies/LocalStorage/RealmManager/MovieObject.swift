//
//  MovieObject.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var originalTitle: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var overview: String = ""
    @objc dynamic var posterPath: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
