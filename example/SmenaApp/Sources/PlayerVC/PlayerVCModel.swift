//
//  PlayerVCModel.swift
//  SmenaApp
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import Foundation
import MobileCoreServices
import Smena


class PlayerVCModel {

    // MARK: - Properties
    var playbackStatus: PlaybackStatus = .stopped
    var playbackTime: String {
        get {
            let components = NSDateComponents()
            components.second = Int(max(0.0, player.playbackTime))
            return timeRemainingFormatter.string(from: components as DateComponents)!
        }
    }

    private let player: BasicPlayer
    private weak var delegate: PlayerVCModelDelegate?

    private let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()


    // MARK: - Lyfecycle
    init(player: BasicPlayer, delegate: PlayerVCModelDelegate) {
        self.player = player
        self.delegate = delegate
        player.delegate = self

        player.loopingEnabled = true
    }

    deinit {
        player.destroy()
    }

    // MARK: - Public
    func startUpdatingUI() {
        player.subscribeToPlayerChanges()
    }

    func stopUpdatingUI() {
        player.unsubscribeFromPlayerChanges()
    }

    func startPlayer() {
        player.start()
        delegate?.playbackStatusChanged()
    }

    func pausePlayer() {
        player.pause()
        delegate?.playbackStatusChanged()
    }

    func saveToCameraRoll() {
        pausePlayer()
        // saving
    }

    func assetPickedFromLibrary(info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        guard mediaType == kUTTypeMovie as String  else { return }
        let url = info[UIImagePickerControllerMediaURL] as! URL
        startClip(url: url)
    }

    // MARK: - DEBUG
    func startTestVideo() {
        let url = Bundle.main.url(forResource: "OkGo_8sec", withExtension: "mp4")!
        startClip(url: url)
    }

    // MARK: - Private
    private func startClip(url: URL) {
        let item = PlayerSessionItem(url: url)
        let session = PlayerSession(items: [item])
        player.setSession(session: session)
        startPlayer()
    }
}


// ----------------------------------------------------------------------------
// MARK: - BasicPlayerDelegate
// ----------------------------------------------------------------------------
extension PlayerVCModel: BasicPlayerDelegate {

    func playbackTimeDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.playbackTimeChanged()
        }
    }

    func playbackRateDidChange() {
        DispatchQueue.main.async {  [weak self] in
            self?.playbackStatus = (self?.player.playbackRate == 0.0) ? .onPause : .isPlaying
            self?.delegate?.playbackStatusChanged()
        }
    }

    func itemStatusDidChange() {
//        DispatchQueue.main.async { [weak self] in
//
//        }
    }
}


protocol PlayerVCModelDelegate: class {
    func playbackStatusChanged()
    func playbackTimeChanged()
}


enum PlaybackStatus {
    case isPlaying, onPause, stopped
}
