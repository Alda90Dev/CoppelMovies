//
//  NetworkRouter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation

enum NetworkRouter {
    case getToken
    case sessionLogin(body: Data)
    case createSession(body: Data)
    case accountDetail(sessionId: String)
    case getPopular(page: String)
    case getTopRated(page: String)
    case getUpcomings(page: String)
    case getNowPlaying(page: String)
    case getMovieDetail(id: Int)
    case getVideos(id: Int)
    
    private static let baseURLString = "https://api.themoviedb.org/3"
    private static let apiKey = "608cfab9393cf6de1a420e80a1c19ffb"
    static let service = "themoviedb.org"
    
    private enum HTTTPMethod {
        case get
        case post
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            }
        }
    }
    
    private var method: HTTTPMethod {
        switch self {
        case .getToken: return .get
        case .sessionLogin: return .post
        case .createSession: return .post
        case .accountDetail: return .get
        case .getPopular: return .get
        case .getTopRated: return .get
        case .getUpcomings: return .get
        case .getNowPlaying: return .get
        case .getMovieDetail: return .get
        case .getVideos: return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getToken:
            return "/authentication/token/new"
        case .sessionLogin:
            return "/authentication/token/validate_with_login"
        case .createSession:
            return "/authentication/session/new"
        case .accountDetail:
            return "/account"
        case .getPopular:
            return "/movie/popular"
        case .getTopRated:
            return "/movie/top_rated"
        case .getUpcomings:
            return "/movie/upcoming"
        case .getNowPlaying:
            return "/movie/now_playing"
        case .getMovieDetail(let id):
            return "/movie/\(id)"
        case .getVideos(let id):
            return "/movie/\(id)/videos"
        }
    }
    
    func request() throws -> URLRequest {
        let urlString = "\(NetworkRouter.baseURLString)\(path)"
        
        guard let baseURL = URL(string: urlString),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
                else { throw NetworkErrorType.parseUrlFail }
    
        components.queryItems = [
            URLQueryItem(name: "api_key", value: NetworkRouter.apiKey)
        ]
        
        switch self {
        case .getPopular(let page), .getTopRated(let page), .getUpcomings(let page), .getNowPlaying(let page):
            let query: [URLQueryItem] = [URLQueryItem(name: "page", value: page)]
            components.queryItems?.append(contentsOf: query)
        case .accountDetail(let sessionId):
            let query: [URLQueryItem] = [URLQueryItem(name: "session_id", value: sessionId)]
            components.queryItems?.append(contentsOf: query)
        default:
            break
        }
        
        
        guard let url = components.url else { throw NetworkErrorType.parseUrlFail }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .sessionLogin(let body), .createSession(let body):
            request.httpBody = body
        default:
            break
        }
        
        return request
    }
}
