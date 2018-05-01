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
 KVO context used to differentiate KVO callbacks for this class versus other
 classes in its class hierarchy.
 */
private var basicPlayerKVOContext = 0


/**
 The class inherits from NSObject only because
 LowLevelPlayer has to conform NSObjectProtocol as AVPlayerItemOutputPullDelegate
 */
public class BasicPlayer: NSObject {

    // MARK: - Properties
    @objc let avPlayer = AVPlayer()
    public var loopingEnabled = false

    public private(set) var playbackTime: Double = 0.0
    public private(set) var playbackRate: Double = 0.0
    public private(set) var itemStatus: AVPlayerItemStatus = .unknown

    public weak var delegate: BasicPlayerDelegate?
    
    init(view: UIView) {
        super.init()
        subscribeToNotifications()
        avPlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 1),
            queue: nil) { [weak self] (time) in
                self?.playbackTime = Double(CMTimeGetSeconds(time))
                self?.delegate?.playbackTimeDidChange()
        }
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

    @objc private func playbackDidFinish(notification: Notification) {
        guard loopingEnabled else { return }
        avPlayer.seek(to: kCMTimeZero)
        avPlayer.play()
    }
}


// ----------------------------------------------------------------------------
// MARK: - KVO extension
// ----------------------------------------------------------------------------
extension BasicPlayer {

    public func subscribeToPlayerChanges() {
        /**
         Update the UI when these player properties change.

         Use the context parameter to distinguish KVO for our particular observers
         and not those destined for a subclass that also happens to be observing
         these properties.
         */
        addObserver(
            self,
            forKeyPath: #keyPath(BasicPlayer.avPlayer.currentItem.duration),
            options: [.new, .initial],
            context: &basicPlayerKVOContext
        )
        addObserver(
            self,
            forKeyPath: #keyPath(BasicPlayer.avPlayer.rate),
            options: [.new, .initial],
            context: &basicPlayerKVOContext
        )
        addObserver(
            self,
            forKeyPath: #keyPath(BasicPlayer.avPlayer.currentItem.status),
            options: [.new, .initial],
            context: &basicPlayerKVOContext
        )
    }

    public func unsubscribeFromPlayerChanges() {
        removeObserver(self, forKeyPath: #keyPath(BasicPlayer.avPlayer.currentItem.duration), context: &basicPlayerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(BasicPlayer.avPlayer.rate), context: &basicPlayerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(BasicPlayer.avPlayer.currentItem.status), context: &basicPlayerKVOContext)
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &basicPlayerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        if keyPath == #keyPath(BasicPlayer.avPlayer.currentItem.duration) {
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
            }
            else {
                newDuration = kCMTimeZero
            }

            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            let currentTime = hasValidDuration ? Double(CMTimeGetSeconds(avPlayer.currentTime())) : 0.0
        }
        else if keyPath == #keyPath(BasicPlayer.avPlayer.rate) {
            if let newRate = (change?[NSKeyValueChangeKey.newKey] as? NSNumber)?.doubleValue {
                playbackRate = newRate
            } else {
                playbackRate = 0.0
            }
            delegate?.playbackRateDidChange()
        }
        else if keyPath == #keyPath(BasicPlayer.avPlayer.currentItem.status) {
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                itemStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            }
            else {
                itemStatus = .unknown
            }
            delegate?.itemStatusDidChange()
        }
    }
}


public protocol BasicPlayerDelegate: class {
    func playbackTimeDidChange()
    func playbackRateDidChange()
    func itemStatusDidChange()
}
