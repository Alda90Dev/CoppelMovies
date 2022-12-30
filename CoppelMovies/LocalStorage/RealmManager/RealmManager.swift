//
//  RealmManager.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 30/12/22.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private static var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch {
                debugPrint("Could not access database: ", error)
            }
            return self.realm
        }
    }
    
    class var shared: RealmManager {
        struct Static {
            static let instance = RealmManager()
        }
      
        return Static.instance
    }
    
    func save(movie: Movie) {
        
        guard let _ = RealmManager.realm.object(ofType: MovieObject.self, forPrimaryKey: movie.id) else {
            let object = convertMovieToMovieObject(movie: movie)
            
            RealmManager.realm.beginWrite()
            RealmManager.realm.add(object)
            do {
                try RealmManager.realm.commitWrite()
            } catch {
                debugPrint("Could not write to database: ", error)
            }
            return
        }
        
        return
    }
    
    func render() -> [Movie] {
        var movies: [Movie] = []
        let objects = RealmManager.realm.objects(MovieObject.self)
        
        for obj in objects {
            let movie = convertMovieObjectToMovie(movieObject: obj)
            movies.append(movie)
        }
        
        return movies
    }
    
    func delete(movie: Movie) {
        if let specificMovie = RealmManager.realm.object(ofType: MovieObject.self, forPrimaryKey: movie.id) {
            RealmManager.realm.beginWrite()
            RealmManager.realm.delete(specificMovie)
            do {
                try RealmManager.realm.commitWrite()
            } catch {
                debugPrint("Could not write to database: ", error)
            }
        }
    }
}

private extension RealmManager {
    private func convertMovieToMovieObject(movie: Movie) -> MovieObject {
        let movieObject = MovieObject()
        movieObject.id = movie.id
        movieObject.originalTitle = movie.originalTitle ?? ""
        movieObject.releaseDate = movie.releaseDate ?? ""
        movieObject.voteAverage = movie.voteAverage ?? 0.0
        movieObject.overview = movie.overview ?? ""
        movieObject.posterPath = movie.posterPath ?? ""
        
        return movieObject
    }
    
    private func convertMovieObjectToMovie(movieObject: MovieObject) -> Movie {
        let movie = Movie(
            adult: nil,
            backdropPath: nil,
            genreIDS: nil,
            genres: nil,
            id: movieObject.id,
            originalLanguage: nil,
            originalTitle: movieObject.originalTitle,
            overview: movieObject.overview,
            popularity: nil,
            posterPath: movieObject.posterPath,
            releaseDate: movieObject.releaseDate,
            title: nil,
            video: nil,
            voteAverage: movieObject.voteAverage,
            voteCount: nil,
            productionCompanies: nil,
            isFavorite: true)
        
        return movie
    }
}
