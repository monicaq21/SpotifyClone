//
//  AuthResponse.swift
//  Spotify
//
//  Created by Monica Qiu on 8/7/23.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String? // optional because refresh request will not generate refresh token
    let scope: String
    let token_type: String
}
