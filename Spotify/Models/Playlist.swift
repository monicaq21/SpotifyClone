//
//  Playlist.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}

