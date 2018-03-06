//
//  PlayerVC.swift
//  PhotoVideoPlayground
//
//  Created by Dmitrii on 26/02/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit
import MobileCoreServices


class PlayerVC: UIViewController {

    // MARK: - Properties
    @IBOutlet private var toolbar: UIToolbar!


    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startPlayer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pausePlayer()
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
        //player.play()
    }

    private func pausePlayer() {
        //player.pause()
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
                // open clip from URL
                // add clip to the session
                self.startPlayer()
            }
        }
    }
}


// MARK: - UINavigationControllerDelegate
extension PlayerVC: UINavigationControllerDelegate {
}
