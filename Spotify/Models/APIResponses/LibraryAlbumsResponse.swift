//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Monica Qiu on 8/27/23.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
