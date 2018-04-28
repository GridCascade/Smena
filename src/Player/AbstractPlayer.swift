//
//  AbstractPlayer.swift
//  Smena
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import Foundation
import AVFoundation

public protocol AbstractPlayer {

    init(view: UIView)

    func start()
    func pause()
    func setSession(session: PlayerSession)
    func setAsset(asset: AVAsset)
    func replaceCurrentItem(with item: AVPlayerItem?)
    func destroy()
}
