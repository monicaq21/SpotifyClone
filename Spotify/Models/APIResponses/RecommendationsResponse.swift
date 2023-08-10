//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Monica Qiu on 8/10/23.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
