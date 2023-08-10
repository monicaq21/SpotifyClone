//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Monica Qiu on 8/10/23.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumResponse
}

struct AlbumResponse: Codable {
    let items: [Album]
}
