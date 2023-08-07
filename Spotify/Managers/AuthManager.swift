//
//  AuthManager.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "6566e210303c4325b6736b909fdcdcef"
        static let clientSecret = "2753f8d7da084bca8af8a0c0a670cfa3"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let redirectURI = "https://localhost:8080"
        let scopes = "user-read-private"
        
        
        let baseURL = "https://accounts.spotify.com/authorize"
        let fullURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        
        return URL(string: fullURL)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    
}
