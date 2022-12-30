//
//  NetworkResult.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation

enum NetworkResult<T> {
    case success(data: T)
    case failure(error: Error)
}

enum NetworkErrorType: LocalizedError {
    case parseUrlFail
    case invalidResponse
    case dataError
    case serverError
    case customizedError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .parseUrlFail:
            return "Cannot initial URL object"
        case .invalidResponse:
            return "Invalid Response"
        case .dataError:
            return "Invalid data"
        case .serverError:
            return "Internal Server Error"
        case .customizedError(let message):
            return message
        }
    }
}

struct CustomError: Codable {
    let statusMessage: String?
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

