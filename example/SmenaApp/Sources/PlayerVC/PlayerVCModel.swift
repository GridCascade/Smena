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
    private let player: BasicPlayer
    private weak var delegate: PlayerVCModelDelegate?


    // MARK: - Lyfecycle
    init(player: BasicPlayer, delegate: PlayerVCModelDelegate) {
        self.player = player
        self.delegate = delegate

        // TEST VIDEO
        let url = Bundle.main.url(forResource: "OkGo_8sec", withExtension: "mp4")!
        startClip(url: url)
        //

        player.loopingEnabled = true
    }

    deinit {
        player.destroy()
    }

    // MARK: - Public
    func startPlayer() {
        player.start()
    }

    func pausePlayer() {
        player.pause()
    }

    func saveToCameraRoll() {
        player.pause()
        // saving
    }

    func assetPickedFromLibrary(info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        guard mediaType == kUTTypeMovie as String  else { return }
        let url = info[UIImagePickerControllerMediaURL] as! URL
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


protocol PlayerVCModelDelegate: class {
    
}
