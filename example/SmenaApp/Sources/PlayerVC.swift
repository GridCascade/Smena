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

    // MARK: - Properties
    @IBOutlet private var toolbar: UIToolbar!

    // LowLevel -- CADisplayLink
    @IBOutlet private var llRendererView: LowLevelRendererView!
//    var llPlayer: LowLevelPlayer!

    // HighLevel -- AVPlayerLayer
    @IBOutlet private var hlRendererView: HighLevelRendererView!
    var hlPlayer: HighLevelPlayer!

    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // LowLevelPlayer
//        llPlayer = LowLevelPlayer(view: llRendererView)
//        llRendererView.isHidden = false

        // HighLevelPlayer
        hlPlayer = HighLevelPlayer(view: hlRendererView)
        hlRendererView.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startPlayer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pausePlayer()
    }

    deinit {
        //llPlayer.destroy()
    }

    // MARK: - Public


    // MARK: - Private
    private func saveToCameraRoll() {
        //player.pause()
    }

    private func openMediaPicker() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    private func startPlayer() {
        //llPlayer.start()
        hlPlayer.start()
    }

    private func pausePlayer() {
        //llPlayer.pause()
        hlPlayer.pause()
    }


    // MARK: - Actions
    @IBAction func saveButtonPressed() {
        saveToCameraRoll()
    }

    @IBAction func addClipPressed() {
        openMediaPicker()
    }

    @IBAction func filtersPressed() {

    }
}


// MARK: - UIImagePickerControllerDelegate
extension PlayerVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        dismiss(animated: true) {
            if mediaType == kUTTypeMovie as String {
                let url = info[UIImagePickerControllerMediaURL] as! URL
                let item = PlayerSessionItem(url: url)
                let session = PlayerSession(items: [item])
                //self.llPlayer.setSession(session: session)
                self.hlPlayer.setSession(session: session)
                self.startPlayer()
            }
        }
    }
}


// MARK: - UINavigationControllerDelegate
extension PlayerVC: UINavigationControllerDelegate {
}
