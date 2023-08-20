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
    
    // MARK: - Browse
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data,
                        error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    completion(.failure(error))
                }
                
            }
            
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data,
                        error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    completion(.failure(error))
                }
                
            }
            
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data,
                        error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))

                } catch {
                    completion(.failure(error))
                }

            }

            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data,
                        error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    completion(.failure(error))
                }
                
            }
            
            task.resume()
        }
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(model))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(model))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Category
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(model.categories.items))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=20"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    
                    // returned data can have nil playlist element, so do a small conversion here.
                    let optionalPlaylists = model.playlists.items
                    var playlists = [Playlist]()
                    for optionalPlaylist in optionalPlaylists {
                        if let optionalPlaylist = optionalPlaylist {
                            playlists.append(optionalPlaylist)
                        }
                    }
                    
                    completion(.success(playlists))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Profile
    
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
                    completion(.success(model))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: - Search
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let type = "album,artist,playlist,track"
        let urlString = Constants.baseAPIURL + "/search?type=\(type)&q=\(encodedQuery)"
        
        createRequest(with: URL(string: urlString),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    
                    var searchResults = [SearchResult]()
                    searchResults.append(contentsOf: model.albums.items.compactMap({ album in
                        SearchResult.album(model: album)
                    }))
                    searchResults.append(contentsOf: model.artists.items.compactMap({ artist in
                        SearchResult.artist(model: artist)
                    }))
                    searchResults.append(contentsOf: model.playlists.items.compactMap({ playlist in
                        SearchResult.playlist(model: playlist)
                    }))
                    searchResults.append(contentsOf: model.tracks.items.compactMap({ track in
                        SearchResult.track(model: track)
                    }))
                    
                    completion(.success(searchResults))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: - General
    
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
