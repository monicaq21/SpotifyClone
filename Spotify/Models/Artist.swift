//
//  Artist.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    let images: [APIImage]?
}
