//
//  ProfileViewController.swift
//  sevcabel
//
//  Created by Никита Бабенко on 09/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit
//import SwiftyVK
import  Firebase
import FirebaseDatabase
//import VK_ios_sdk

class _Item {
    
    var ref: DatabaseReference?
    
    var avatarView: String?
    var dateLabel: String?
    var eventNameLabel: String?
    var eventDescriptionLabel: String?
    
    init (data: (key: String, value: Any)) {
        //ref = snapshot.ref
        
        //let data = snapshot.value as! Dictionary<String, Any>
        guard let info = data.value as? [String: Any] else {return}
        //print(info)
        avatarView = info["image"] as? String
        dateLabel = info["date"]! as? String
        eventNameLabel = info["title"]! as? String
        eventDescriptionLabel = info["description"]! as? String
        //print(dateLabel, "⏰")
    }
    
}

class ProfileViewController: UIViewController {
    var vkHandler: VkHandler?
    
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    let identifier = String(describing: HistoryCell.self)
    var news: [_Item]? = []
    
    var data: [String: String] = ["first_name": "Никита", "last_name": "Бабенко", "id": "2f5e4c5414584f4f", "image": "https://pp.userapi.com/c604728/v604728446/4e90f/QUvGzCpa1MU.jpg"]
    var firstName: String?
    var lastName: String?
    var id: String?
    var image: String?
    @IBOutlet weak var logOutButton: UIButton!
    @IBAction func logOutButton(_ sender: Any) {
        //VK.sessions.default.logOut()
        performSegue(withIdentifier: "toLogInView", sender: sender)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = #colorLiteral(red: 0, green: 0.242123574, blue: 0.5712447166, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        ref = Database.database().reference()
        startObservingDatabase()
        
        view.addSubview(statusBarView)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        /*let data = VKApi.users().get()
        data?.execute(resultBlock: { (response) in
            print(response?.json)
            print("💡")
        }, errorBlock: { (error) in
            print(error?.localizedDescription, "💊")
            })*/
        /*let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.hackathon.queue", qos: .userInitiated, attributes: .concurrent)
        group.enter()
        queue.async {
        VK.API.Users.get(.empty)
            .onSuccess {
                let response = try JSONSerialization.jsonObject(with: $0)
                guard let object = response as? [Dictionary<String, AnyObject>] else {print("JSON is invalid"); return}
                let onlyObject = object[0]
                print(object)
                guard let firstname = onlyObject["first_name"] as? String,
                    let lastname = onlyObject["last_name"] as? String,
                    let id = onlyObject["id"] as? String
                else {return}
                self.firstName = firstname
                self.lastName = lastname
                self.id = id
                //print(firstname, lastname)
                group.leave()
            }
            .onError { error in print(error.localizedDescription) }
            .send()
            }
        group.notify(queue: queue) {
            print("kek")
            print(self.firstName, self.lastName, self.id, "😘")
            guard let firstname = self.firstName,
                let lastname = self.lastName
                else {return}
            print(firstname, lastname, "🤯")
            //self.nameLabel.text = "\(firstname) \(lastname)"
            group.enter()
            VK.API.Users.get([
                .userId: "1",
                .fields: "sex,bdate,city"
                ])
                .onSuccess {
                    let response = try JSONSerialization.jsonObject(with: $0)
                    print(response)
                    //self.nameLabel.text = response["fields"]["first_name"] + response["fields"]["last_name"]
                    print("kek§|")
                    group.leave()
                }
                .onError { error in print(error.localizedDescription) }
                .send()
            group.notify(queue: queue) {
                
            }
        }
        */
        image = data["image"]
        firstName = data["first_name"]
        lastName = data["last_name"]
        id = data["id"]
        guard let _image = image,
            let _firstName = firstName,
            let _lastName = lastName
        else {return}
        self.nameLabel.text = "\(_firstName) \(_lastName)"
        let url = URL(string:_image)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.avatarView.image = UIImage(data: data!)
                self.avatarView.layer.masksToBounds = true
                self.avatarView.clipsToBounds = true
                self.avatarView.layer.cornerRadius = self.avatarView.bounds.size.height / 2.0
                self.activityIndicator.stopAnimating()
            }
        }
        //
        //vkHandler = VkHandler()
        //vkHandler?.setUp()
        //VK.setUp(appId: VK_APP_ID, delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("news").observe(.value, with: { (snapshot) in
            var newNews = [_Item]()
            
            let data = snapshot.value as! Dictionary<String, Any>
            for itemSnapShot in data {
                //print(itemSnapShot)
                let item = _Item(data: itemSnapShot)
                newNews.append(item)
            }
            
            self.news = newNews
            self.tableView.reloadData()
            
        })
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

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let amount = news?.count else {return 10}
        return amount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as?
            HistoryCell else {
                fatalError("The dequeued cell is not an instance of HistoryListCell.")
        }
        guard let item = news?[indexPath.row] else {return UITableViewCell()}
        //print(item.avatarView)
        let url = URL(string: item.avatarView!)
        //DispatchQueue.global().async {
        let data = try? Data(contentsOf: url!)
        //DispatchQueue.main.async {
        cell.avatarView.image = UIImage(data: data!)
        //}
        //}
        cell.dateLabel.text = item.dateLabel
        //cell.eventDescriptionLabel.sizeToFit()
        cell.nameLabel.text = item.eventNameLabel
        return cell
    }
}


