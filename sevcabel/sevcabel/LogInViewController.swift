//
//  LogInViewController.swift
//  sevcabel
//
//  Created by Никита Бабенко on 09/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit
import SwiftyVK
//import VK_ios_sdk

class LogInViewController: UIViewController {
    var vkHandler: VkHandler?
    @IBOutlet weak var logInButton: UIButton!
    @IBAction func logInButton(_ sender: Any) {
        
        /*vkHandler?.logIn(onSuccess: {
            self.performSegue(withIdentifier: "fromLogInView", sender: sender)
        }, onError: { (error: Error) in
            print(error.localizedDescription)
        })*/
        /*VK.sessions.default.logOut()
        
        VK.sessions.default.logIn(
            onSuccess: { _ in
                self.performSegue(withIdentifier: "fromLogInView", sender: sender)
        },
            onError: { error in
                print(error.localizedDescription)
        })*/
        self.performSegue(withIdentifier: "fromLogInView", sender: sender)
        //VKSdk.authorize([])*/
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
        //vkHandler = VkHandler()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
