//
//  Player.swift
//  Smena
//
//  Created by Dmitrii on 06/03/2018.
//  Copyright © 2018 Andrei Valkovskii. All rights reserved.
//

import Foundation
import AVFoundation

public class Player: NSObject {

    // MARK: - Properties
    private var caDisplayLink: CADisplayLink!
    private var avVideoOutput: AVPlayerItemVideoOutput!
    private var avPlayer: AVPlayer!

    private var videoOutputQueue: DispatchQueue!
    private weak var rendererView: RendererView?

    // MARK: - Lyfecycle
    public init(view: RendererView) {
        super.init()

        avPlayer = AVPlayer()

        rendererView = view

        setupVideoOutput(forItem: avPlayer.currentItem)

        caDisplayLink = CADisplayLink(target: self, selector: #selector(displayLinkCallback(_:)))
        caDisplayLink.add(to: .main, forMode: .defaultRunLoopMode)
        //caDisplayLink.add(to: .current, forMode: .defaultRunLoopMode)

        suspendDisplay()
    }

    // MARK: - Public
    public func start() {
        avPlayer.play()
        resumeDisplay()
    }

    public func pause() {
        avPlayer.pause()
        suspendDisplay()
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
        setupVideoOutput(forItem: item)
        suspendDisplay()
    }

    public func destroy() {
        destroyCADisplayLink()
        removeAVVideoOutput()
    }

    // MARK: - Private
    @objc private func displayLinkCallback(_ displayLink: CADisplayLink) {
        let nextFrameTime = displayLink.timestamp + displayLink.duration
        let outputItemTime = avVideoOutput.itemTime(forHostTime: nextFrameTime)
        guard avVideoOutput.hasNewPixelBuffer(forItemTime: outputItemTime) else { return }

        var timeForDisplay = CMTime()
        let pixelBuffer = avVideoOutput.copyPixelBuffer(forItemTime: outputItemTime, itemTimeForDisplay: &timeForDisplay)
        guard let buffer = pixelBuffer else { return }

        guard rendererView != nil else { return }
        rendererView!.ciTime = CMTimeGetSeconds(outputItemTime)
        rendererView!.ciImage = CIImage(cvPixelBuffer: buffer)

        //CFRelease(buffer);
    }

    func setupVideoOutput(forItem item: AVPlayerItem?) {
        let outputAttributes: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
        avVideoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: outputAttributes)
        videoOutputQueue = DispatchQueue(label: "com.smena.player.videoOutput")
        avVideoOutput.setDelegate(self, queue: videoOutputQueue)
        item?.add(avVideoOutput)
    }

    private func suspendDisplay() {
        caDisplayLink.isPaused = true
    }

    private func resumeDisplay() {
        caDisplayLink.isPaused = false
    }

    private func destroyCADisplayLink() {
        caDisplayLink.invalidate()
        caDisplayLink = nil
    }

    private func removeAVVideoOutput() {
        guard let item = avPlayer.currentItem else { return }
        guard item.outputs.contains(avVideoOutput) else { return }
        item.remove(avVideoOutput)
        avVideoOutput = nil
    }
}


extension Player: AVPlayerItemOutputPullDelegate {

    public func outputMediaDataWillChange(_ sender: AVPlayerItemOutput) {
        resumeDisplay()
    }
}
