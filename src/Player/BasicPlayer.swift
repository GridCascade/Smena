//
//  BasicPlayer.swift
//  Smena
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import Foundation
import AVFoundation


/**
 The class inherits from NSObject only because
 LowLevelPlayer has to conform NSObjectProtocol as AVPlayerItemOutputPullDelegate
 */
public class BasicPlayer: NSObject {

    // MARK: - Properties
    let avPlayer = AVPlayer()
    public var loopingEnabled = false
    
    init(view: UIView) {
        super.init()
        subscribeToNotifications()
    }

    // MARK: - Public
    public func start() {
        avPlayer.play()
    }

    public func pause() {
        avPlayer.pause()
    }

    public func destroy() {
        unsubscribeFromNotifications()
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

    // MARK: - Private
    private func subscribeToNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(playbackDidFinish(notification:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    private func subscribeToPlayerChanges() {

    }

    private func unsubscribeFromPlayerChanges() {

    }

    @objc private func playbackDidFinish(notification: Notification) {
        guard loopingEnabled else { return }
        avPlayer.seek(to: kCMTimeZero)
        avPlayer.play()
    }
}
