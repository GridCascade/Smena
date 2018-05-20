//
//  VCFactory.swift
//  SmenaApp
//
//  Created by Dmitrii on 28/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import UIKit

final class VCFactory {

    static func firstVC() -> ViewController {
        return mainStoryboard.initial()
    }

    static func playerVC() -> PlayerVC {
        return mainStoryboard.instantiate()
    }

    static func recorderVC() -> RecorderVC {
        return mainStoryboard.instantiate()
    }
    
    private static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

protocol FromStoryboard
{
    static var storyboardId: String { get }
}

extension FromStoryboard where Self: UIViewController
{
    static var storyboardId: String {
        return String(describing: self)
    }
}

extension UIStoryboard
{
    func initial<T: UIViewController>() -> T
    {
        return instantiateInitialViewController() as! T
    }
    
    func instantiate<T: UIViewController>() -> T where T: FromStoryboard
    {
        return instantiateViewController(withIdentifier: T.storyboardId) as! T
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
