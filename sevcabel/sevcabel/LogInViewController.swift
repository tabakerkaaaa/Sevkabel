//
//  LogInViewController.swift
//  sevcabel
//
//  Created by Никита Бабенко on 09/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit
import SwiftyVK

class LogInViewController: UIViewController {
    var vkHandler: VkHandler?
    @IBOutlet weak var logInButton: UIButton!
    @IBAction func logInButton(_ sender: Any) {
        
        vkHandler?.logIn(onSuccess: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "fromLogInView", sender: sender)
            }
        }, onError: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = #colorLiteral(red: 0, green: 0.242123574, blue: 0.5712447166, alpha: 1)
        logInButton.layer.cornerRadius = 10
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        vkHandler = VkHandler()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
}
