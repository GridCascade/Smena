//
//  RecorderVC.swift
//  PhotoVideoPlayground
//
//  Created by Dmitrii on 25/02/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

class RecorderVC: UIViewController, FromStoryboard {

    // MARK: - Properties
    @IBOutlet private var preview: UIView!
    @IBOutlet private var recButton: UIButton!

    private var recording = false

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeRecorder()
        recButton.layer.cornerRadius = recButton.frame.width/2
        updateRecButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //recorder.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //recorder.stopRunning()
    }

    // MARK: - Public
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayer" {

        }
    }


    // MARK: - Private
    private func initializeRecorder() {

    }

    private func updateRecButtonState() {
        if recording {
            recButton.backgroundColor = UIColor.green
        } else {
            recButton.backgroundColor = UIColor.red
        }
    }

    // MARK: - Actions
    @IBAction func recButtonPressed(_ sender: UIButton) {
        if recording {
            //recorder.pause()
        } else {
            //recorder.record()

        }
        recording = !recording
        updateRecButtonState()
    }

    @IBAction func finishButtonPressed() {
        //recorder.pause()
    }
}
