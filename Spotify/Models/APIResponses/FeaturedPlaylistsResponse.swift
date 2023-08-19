//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Monica Qiu on 8/10/23.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: OptionalPlaylistResponse
}

struct OptionalPlaylistResponse: Codable {
    let items: [Playlist?]
}

