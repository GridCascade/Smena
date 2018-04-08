//
//  PlayerSessionItem.swift
//  Smena
//
//  Created by Dmitrii on 25/03/2018.
//  Copyright © 2018 Andrei Valkovskii. All rights reserved.
//

import AVFoundation

public class PlayerSessionItem {

    let url: URL
    let asset: AVAsset
    let duration: CMTime

    public init(url: URL) {
        self.url = url
        self.asset = AVAsset(url: url)
        self.duration = asset.duration
    }
}
