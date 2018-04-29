//
//  VCFactory.swift
//  SmenaApp
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import UIKit


class VCFactory: NSObject {

    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func firstVC() -> ViewController {
        return mainStoryboard().instantiateInitialViewController() as! ViewController
    }

    func playerVC() -> PlayerVC {
        return mainStoryboard().instantiateViewController(withIdentifier: String(describing: PlayerVC.self)) as! PlayerVC
    }

    func recorderVC() -> RecorderVC {
        return mainStoryboard().instantiateViewController(withIdentifier: String(describing: RecorderVC.self)) as! RecorderVC
    }
}


extension UIViewController {

    func wrapped() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.tintColor = UIColor.green
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        return navigationController
    }
}
