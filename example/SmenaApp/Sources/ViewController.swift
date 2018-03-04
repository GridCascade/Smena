//
//  ViewController.swift
//  PhotoVideoPlayground
//
//  Created by Dmitrii on 24/02/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit


class ViewController: UIViewController {

    private var pickerController: UIImagePickerController?
    private var cameraController: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
    }

    @IBAction func playPressed(_ sender: UIButton) {
        let _ = startMediaBrowserFromViewController(viewController: self, usingDelegate: self)
    }

    @IBAction func recordPressed(_ sender: UIButton) {
        let _ = startCameraFromViewController(viewController: self, withDelegate: self)
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false {
            return false
        }

        pickerController = UIImagePickerController()
        pickerController!.sourceType = .savedPhotosAlbum
        pickerController!.mediaTypes = [kUTTypeMovie as NSString as String]
        pickerController!.allowsEditing = true
        pickerController!.delegate = delegate

        present(pickerController!, animated: true, completion: nil)
        return true
    }

    func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }

        cameraController = UIImagePickerController()
        cameraController!.sourceType = .camera
        cameraController!.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController!.allowsEditing = false
        cameraController!.delegate = delegate

        present(cameraController!, animated: true, completion: nil)
        return true
    }

    @objc func video(atPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        dismiss(animated: true) {
            if mediaType == kUTTypeMovie as String {
                if picker == self.pickerController {
                    let player = AVPlayer(url: info[UIImagePickerControllerMediaURL] as! URL)
                    let playerVC = AVPlayerViewController()
                    playerVC.player = player
                    self.present(playerVC, animated: true, completion: nil)
                } else if picker == self.cameraController {
                    let path = (info[UIImagePickerControllerMediaURL] as! URL).path
                    if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                        UISaveVideoAtPathToSavedPhotosAlbum(
                            path,
                            self,
                            #selector(self.video(atPath:didFinishSavingWithError:contextInfo:)),
                            nil
                        )
                    }
                }
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
}
