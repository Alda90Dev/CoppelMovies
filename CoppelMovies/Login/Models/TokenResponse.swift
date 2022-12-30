//
//  TokenResponse.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation

struct TokenResponse: Codable {
    let success: Bool
    let expiresAt, requestToken: String?
    let session_id: String?

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case session_id
    }
}
