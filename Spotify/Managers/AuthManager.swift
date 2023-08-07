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
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://localhost:8080"
        static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        
        let baseURL = "https://accounts.spotify.com/authorize"
        let fullURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: fullURL)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        
        // refresh tokens when there's <5 mins left for the tokens
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token { // prevents nil in refresh request from covering the original refresh token
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration_date")
    }
    
    private func makeTokenRequest(url: URL, code: String) -> URLRequest? {
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let basicData = basicToken.data(using: .utf8)
        guard let basic64String = basicData?.base64EncodedString() else {
            print("Failed to get base64 basic string")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        let request = makeTokenRequest(url: url, code: code)
        guard let request = request else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        
        task.resume()
        
    }
    
    private func makeRefreshRequest(url: URL, refreshToken: String) -> URLRequest? {
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let basicData = basicToken.data(using: .utf8)
        guard let basic64String = basicData?.base64EncodedString() else {
            print("Failed to get base64 basic string")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    public func refreshIfNeeded(completion: @escaping ((Bool) -> Void)) {
        
        guard let refreshToken = refreshToken else { return }
        
        // refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        let request = makeRefreshRequest(url: url, refreshToken: refreshToken)
        guard let request = request else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        
        task.resume()
        
    }
    
    
}
