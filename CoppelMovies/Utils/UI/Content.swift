//
//  Content.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation

struct Content {
    static let loading: String = "Loading..."
    static let required: String = "Required"
    static let userName: String = "Username"
    static let Password: String = "Password"
    static let logIn: String = "Log In"
    static let errorMessage: String = "We are sorry, and error has ocurred!"
    static let moviesTitle: String = "Movies"
    static let favoritesTitle: String = "Mis Favoritos"
    static let btnVideos: String = "Ver videos"
    static let productions: String = "Production Companies"
    
    struct alert {
        static let okMessage: String = "Ok"
        static let alertMessage: String = "What do you want to do?"
        static let viewProfile: String = "View Profile"
        static let viewFavorites: String = "View Favorites"
        static let logOut: String = "Log out"
        static let cancel: String = "Cancel"
    }
    
    struct K {
        static let star: String = "\u{2606}"
        static let image: String = "image"
    }
    
    struct Segment {
        static let popular: String = "Popular"
        static let topRated: String = "Top Rated"
        static let upcoming: String = "Upcoming"
        static let nowPlaying: String = "Now Playing"
    }
    
    
    struct BodyLabel {
        static let username: String = "username"
        static let password: String = "password"
        static let requestToken: String = "request_token"
    }
}
