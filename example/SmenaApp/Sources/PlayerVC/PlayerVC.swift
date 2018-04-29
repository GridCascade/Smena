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
    @IBOutlet private var rendererView: HighLevelRendererView!

    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let player = HighLevelPlayer(view: rendererView)
        model = PlayerVCModel(player: player, delegate: self)

        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: .default)
        toolbar.tintColor = UIColor.green
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.startPlayer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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


    // MARK: - Actions
    @IBAction func saveButtonPressed() {
        model.saveToCameraRoll()
    }

    @IBAction func addClipPressed() {
        openMediaPicker()
    }

    @IBAction func filtersPressed() {

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

}
