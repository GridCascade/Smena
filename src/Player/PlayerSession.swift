//
//  PlayerSession.swift
//  Smena
//
//  Created by Dmitrii on 25/03/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import AVFoundation

public class PlayerSession {

    // MARK: - Properties
    var items: [PlayerSessionItem]

    // MARK: - Lyfecycle
    public init(items: [PlayerSessionItem]) {
        self.items = items
    }

    // MARK: - Public
    func addItem(item: PlayerSessionItem) {
        items.append(item)
    }

    func combinedAsset() -> AVAsset? {
        if items.count == 0 {
            return nil
        } else if items.count == 1 {
            return items.first!.asset
        } else {
            // assets using AVMutableComposition
            return nil
        }
    }

    // MARK: - Private
}
