//
//  FeedViewController.swift
//  sevcabel
//
//  Created by Никита Бабенко on 09/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit
import SwiftyVK
import Firebase
import FirebaseDatabase
//import Firebase.Unity.Editor

class Item {
    
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

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var news: [Item]? = []
    let identifier = String(describing: FeedCell.self)
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = #colorLiteral(red: 0, green: 0.242123574, blue: 0.5712447166, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        //self.tableView.estimatedRowHeight = 240
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        ref = Database.database().reference()
        startObservingDatabase()
        //news = ref.child("news")
        //print(news)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("news").observe(.value, with: { (snapshot) in
            var newNews = [Item]()
            
            let data = snapshot.value as! Dictionary<String, Any>
            for itemSnapShot in data {
                //print(itemSnapShot)
                let item = Item(data: itemSnapShot)
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

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let amount = news?.count else {return 10}
        return amount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as?
            FeedCell else {
                fatalError("The dequeued cell is not an instance of FeedCell.")
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
        cell.eventDescriptionLabel.text = item.eventDescriptionLabel
        //cell.eventDescriptionLabel.sizeToFit()
        cell.eventNameLabel.text = item.eventNameLabel
        return cell
    }
}

