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
    @IBOutlet private var playerView: RendererView!

    var player: Player!


    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        player = Player(view: playerView)
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
        player.destroy()
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
        player.start()
    }

    private func pausePlayer() {
        player.pause()
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
                self.player.setSession(session: session)
                self.startPlayer()
            }
        }
    }
}


// MARK: - UINavigationControllerDelegate
extension PlayerVC: UINavigationControllerDelegate {
}
