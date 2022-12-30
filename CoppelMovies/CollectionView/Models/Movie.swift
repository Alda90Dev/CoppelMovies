//
//  Movie.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation

// MARK: - MovieResponse
struct MovieResponse: Codable {
    let page: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
    }
}

// MARK: - Result
struct Movie: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let genres: [Genres]?
    let id: Int
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let productionCompanies: [ProductionCompanies]?
    var isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres
        case productionCompanies = "production_companies"
        case isFavorite
    }
    
    static let baseURLImageString = "https://image.tmdb.org/t/p/w500"
    private static let baseURLImageOriginalString = "https://image.tmdb.org/t/p/original"
    
    func posterPathURL() -> URL? {
        let urlString = "\(Movie.baseURLImageString)\(posterPath ?? "")"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    func backdropPathURL() -> URL? {
        let urlString = "\(Movie.baseURLImageOriginalString)\(backdropPath ?? "")"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    func formattedReleasedDate() -> String {
        if let releaseDate = releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM d, yyyy"
            
            return newDateFormatter.string(from: dateFormatter.date(from: releaseDate ) ?? Date())
        }
        
        return ""
    }
    
    func getGenres() -> String {
        var genresString = ""
        
        if let genres = genres {
            genresString = genres.map { $0.name ?? "" }.joined(separator: " · ")
        }
        
        return genresString
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
      return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
    
}

struct Genres: Codable {
    let id: Int?
    let name: String?
}


struct ProductionCompanies: Codable, Hashable  {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    func logoPathURL() -> URL? {
        let urlString = "\(Movie.baseURLImageString)\(logoPath ?? "")"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: ProductionCompanies, rhs: ProductionCompanies) -> Bool {
      return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}
