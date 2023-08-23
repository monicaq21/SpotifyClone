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
    var index = 0
    
    var playerVC: PlayerViewController?
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let _ = self.playerQueue,
          !tracks.isEmpty {
            return tracks[index]
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
        self.playerVC = vc
    }
    
    func startPlayback(from viewController: UIViewController,
                               tracks: [AudioTrack]) {
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap { track in
            guard let url = URL(string: track.preview_url ?? "") else { return nil }
            return AVPlayerItem(url: url)
        })
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        
        self.playerVC = vc
        
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
        } else if let player = playerQueue {
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
        } else {
            playerQueue?.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
            player?.play()
        } else if var items = playerQueue?.items() {
//            playerQueue?.pause()
//            playerQueue?.currentItem?.currentTime() = .zero
            playerQueue?.play()
        }
    }
    
    
}
