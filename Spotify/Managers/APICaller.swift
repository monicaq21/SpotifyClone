//
//  APICaller.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum HTTPMethod: String {
        case GET, POST
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(model)
                    completion(.success(model))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    func createRequest(with url: URL?,
                       type: HTTPMethod,
                       completion: @escaping (URLRequest) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let url = url else { return }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
            
        }
        
    }
    
}
