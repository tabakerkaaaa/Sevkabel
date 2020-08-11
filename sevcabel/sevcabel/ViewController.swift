//
//  ViewController.swift
//  sevcabel
//
//  Created by Никита Бабенко on 09/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = #colorLiteral(red: 0, green: 0.242123574, blue: 0.5712447166, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
}

