//
//  PlayerVC.swift
//  PhotoVideoPlayground
//
//  Created by Dmitrii on 26/02/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit
import MobileCoreServices
import Smena


class PlayerVC: UIViewController {

    private var model: PlayerVCModel!

    // MARK: - Properties
    @IBOutlet private var toolbar: UIToolbar!
    @IBOutlet private var playPauseButton: UIButton!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var infoLabel: UILabel!

    @IBOutlet private var rendererView: HighLevelRendererView!

    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let player = HighLevelPlayer(view: rendererView)
        model = PlayerVCModel(player: player, delegate: self)

        // DEBUG
        model.startTestVideo()
        //

        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: .default)
        toolbar.tintColor = UIColor.green

        updateTimeLabel()
        updatePlayPauseButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.startUpdatingUI()
        model.startPlayer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.stopUpdatingUI()
        model.pausePlayer()
    }

    // MARK: - Public


    // MARK: - Private
    private func openMediaPicker() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    private func updatePlayPauseButtonState() {
        if model.playbackStatus == .isPlaying {
            playPauseButton.setTitle("ll", for: .normal)
        } else if model.playbackStatus == .onPause {
            playPauseButton.setTitle(">", for: .normal)
        }
    }

    private func updateTimeLabel() {
        timeLabel.text = model.playbackTime
    }


    // MARK: - Actions
    @IBAction func saveButtonPressed() {
        model.saveToCameraRoll()
    }

    @IBAction func addClipPressed() {
        openMediaPicker()
    }

    @IBAction func filtersPressed() {

    }

    @IBAction func playPausePressed() {
        if model.playbackStatus == .isPlaying {
            model.pausePlayer()
        } else if model.playbackStatus == .onPause {
            model.startPlayer()
        }
    }

    @IBAction func backwardPressed() {

    }

    @IBAction func forwardPressed() {
        
    }
}


// ----------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate
// ----------------------------------------------------------------------------
extension PlayerVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        model.assetPickedFromLibrary(info: info)
        dismiss(animated: true, completion: nil)
    }
}


// ----------------------------------------------------------------------------
// MARK: - UINavigationControllerDelegate
// ----------------------------------------------------------------------------
extension PlayerVC: UINavigationControllerDelegate {}


// ----------------------------------------------------------------------------
// MARK: - PlayerVCModelDelegate
// ----------------------------------------------------------------------------
extension PlayerVC: PlayerVCModelDelegate {

    func playbackStatusChanged() {
        updatePlayPauseButtonState()
    }

    func playbackTimeChanged() {
        updateTimeLabel()
    }
}
