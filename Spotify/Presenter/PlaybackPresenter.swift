//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Monica Qiu on 8/20/23.
//

import UIKit

final class PlaybackPresenter {
    
    static func startPlayblack(from viewController: UIViewController,
                               track: AudioTrack) {
        let vc = PlayerViewController()
        vc.title = track.name
        
        let navVC = UINavigationController(rootViewController: vc)
        viewController.present(navVC, animated: true, completion: nil)
    }
    
    static func startPlayblack(from viewController: UIViewController,
                               tracks: [AudioTrack]) {
        let vc = PlayerViewController()
        let navVC = UINavigationController(rootViewController: vc)
        viewController.present(navVC, animated: true, completion: nil)
    }
    
}
