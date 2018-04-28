//
//  HighLevelPlayer.swift
//  Smena
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import Foundation
import AVFoundation


public class HighLevelPlayer: BasicPlayer {

    // MARK: - Properties
    private weak var rendererView: HighLevelRendererView?

    // MARK: - Lyfecycle
    public required override init(view: UIView) {
        assert(view is HighLevelRendererView, "View should be an instance of HighLevelRendererView")
        super.init(view: view)
        rendererView = view as? HighLevelRendererView
        rendererView?.player = avPlayer
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
