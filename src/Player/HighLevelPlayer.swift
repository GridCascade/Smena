//
//  HighLevelPlayer.swift
//  Smena
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import Foundation
import AVFoundation


public class HighLevelPlayer: AbstractPlayer {

    // MARK: - Properties
    private var avPlayer: AVPlayer!
    private weak var rendererView: HighLevelRendererView?

    // MARK: - Lyfecycle
    public required init(view: UIView) {
        assert(view is HighLevelRendererView, "View should be an instance of HighLevelRendererView")
        avPlayer = AVPlayer()
        rendererView = view as? HighLevelRendererView
        rendererView?.player = avPlayer
    }

    // MARK: - Public
    public func start() {
        avPlayer.play()
    }

    public func pause() {
        avPlayer.pause()
    }

    public func destroy() {}

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

    // MARK: - Private
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
