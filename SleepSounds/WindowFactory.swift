//
//  WindowFactory.swift
//  SleepSounds
//
//  Created by Kanstantsin Charnukha on 10/11/19.
//  Copyright © 2019 Kanstantsin Charnukha. All rights reserved.
//

import Foundation
import UIKit

enum WindowFactory {
  static func makeAppWindow() -> UIWindow {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let homeViewController = ViewController()
    homeViewController.title = "Sleep Sounds"
    let navigationController = UINavigationController(rootViewController: homeViewController)
    navigationController.navigationBar.barTintColor = .darkText
    let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
    navigationController.navigationBar.titleTextAttributes = textAttributes
    window.rootViewController = navigationController
    return window
  }
}
