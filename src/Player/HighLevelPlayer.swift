//
//  HighLevelPlayer.swift
//  Smena
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import Foundation
import AVFoundation


public class HighLevelPlayer {

    private var avPlayer: AVPlayer!
    private weak var rendererView: HighLevelRendererView?

    public init(view: HighLevelRendererView) {
        avPlayer = AVPlayer()
        rendererView = view
        rendererView?.player = avPlayer
    }

    public func start() {
        avPlayer.play()
    }

    public func pause() {
        avPlayer.pause()
    }

    public func setSession(session: PlayerSession) {
        guard let asset = session.combinedAsset() else { return }
        setAsset(asset: asset)
    }

    public func setAsset(asset: AVAsset) {
        let newItem = AVPlayerItem(asset: asset)
        replaceCurrentItem(with: newItem)
    }

    public func replaceCurrentItem(with item: AVPlayerItem?) {
        avPlayer.replaceCurrentItem(with: item)
    }
}


/// A simple `UIView` subclass that is backed by an `AVPlayerLayer` layer.
public class HighLevelRendererView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override public class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
