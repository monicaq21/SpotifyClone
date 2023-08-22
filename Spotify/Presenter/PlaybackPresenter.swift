//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Monica Qiu on 8/20/23.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(from viewController: UIViewController,
                               track: AudioTrack) {
        
        guard let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 0.0 // xxx
        
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        self.track = track
        self.tracks = []
        
        let navVC = UINavigationController(rootViewController: vc)
        viewController.present(navVC, animated: true) { [weak self] in
            self?.player?.play()
        }
    }
    
    func startPlayback(from viewController: UIViewController,
                               tracks: [AudioTrack]) {
        let vc = PlayerViewController()
        vc.dataSource = self
        self.tracks = tracks
        self.track = nil
        
//        self.playerQueue = AVQueuePlayer(items: items)
        
        let navVC = UINavigationController(rootViewController: vc)
        viewController.present(navVC, animated: true, completion: nil)
    }
    
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        currentTrack?.name
    }
    
    var subtitle: String? {
        currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
            player?.play()
        } else {
            
        }
    }
    
    func didTapBackward() {
        
    }
    
    
}
