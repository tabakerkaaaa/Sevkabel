//
//  ProfileViewController.swift
//  sevcabel
//
//  Created by Никита Бабенко on 09/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit
import SwiftyVK
import  Firebase
import FirebaseDatabase

class _Item {
    var ref: DatabaseReference?
    
    var avatarView: String?
    var dateLabel: String?
    var eventNameLabel: String?
    var eventDescriptionLabel: String?
    
    init (data: (key: String, value: Any)) {
        guard let info = data.value as? [String: Any] else {return}
        
        avatarView = info["image"] as? String
        dateLabel = info["date"]! as? String
        eventNameLabel = info["title"]! as? String
        eventDescriptionLabel = info["description"]! as? String
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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func logOutButton(_ sender: Any) {
        performSegue(withIdentifier: "toLogInView", sender: sender)
    }
    
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
    }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("news").observe(.value, with: { (snapshot) in
            var newNews = [_Item]()
            
            let data = snapshot.value as! Dictionary<String, Any>
            for itemSnapShot in data {
                let item = _Item(data: itemSnapShot)
                newNews.append(item)
            }
            
            self.news = newNews
            self.tableView.reloadData()
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
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
        let url = URL(string: item.avatarView!)
        let data = try? Data(contentsOf: url!)
        
        cell.avatarView.image = UIImage(data: data!)
        cell.dateLabel.text = item.dateLabel
        cell.nameLabel.text = item.eventNameLabel
        
        return cell
    }
}


