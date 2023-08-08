//
//  SettingsModels.swift
//  Spotify
//
//  Created by Monica Qiu on 8/7/23.
//

import Foundation

struct Option {
    let title: String
    let handler: () -> Void
}

struct Section {
    let title: String
    let options: [Option]
}
