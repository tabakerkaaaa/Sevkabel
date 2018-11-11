//
//  MapViewController.swift
//  sevcabel
//
//  Created by Никита Бабенко on 10/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit
import GoogleMaps
import SwiftyJSON

struct Marker {
    var markerPositionX: Double?
    var markerPositionY: Double?
    var title: String?
    var text: String?
    var type: Int?
}

class MapViewController: UIViewController {
    
    var mapView: GMSMapView?
    
    private var databaseHandle: DatabaseHandle!
    var ref: DatabaseReference!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = #colorLiteral(red: 0, green: 0.242123574, blue: 0.5712447166, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        mapView?.delegate = self
        ref = Database.database().reference()
        let camera = GMSCameraPosition.camera(withLatitude: 59.924331,
                                              longitude: 30.241246,
                                              zoom: 16)
        let frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.view.frame.height - 70)
        mapView = GMSMapView.map(withFrame: frame, camera: camera)
       // mapView.setMinZoom(18, maxZoom: 21)
        //showMarker(position: camera.target)
        mapView?.camera = camera
        mapView?.setMinZoom(16, maxZoom: 18)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView?.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.view.addSubview(mapView!)
        startObservingDatabase()
        
        // Do any additional setup after loading the view.
    }
    func showMarker(myMarker: Marker){
        print("marker \(myMarker)")
        DispatchQueue.main.async
        {
            let marker = GMSMarker()
            guard let px = myMarker.markerPositionX,
                  let py = myMarker.markerPositionY,
                  let title = myMarker.title,
                  let text = myMarker.text,
                  let type = myMarker.type
            else {return}
            
            marker.position = CLLocationCoordinate2D(latitude: px, longitude: py)
            marker.title = title
            marker.snippet = text
            if type == 1 {
                let markerImage = UIImage(named: "food_marker")
                marker.icon = self.image(markerImage!, scaledToSize: CGSize(width: 50, height: 50))
            }
            else {
                let markerImage = UIImage(named: "event_marker")
                marker.icon = self.image(markerImage!, scaledToSize: CGSize(width: 50, height: 50))
            }
            marker.map = self.mapView
        }
    }
    
    func image(_ originalImage:UIImage, scaledToSize:CGSize) -> UIImage {
        if originalImage.size.equalTo(scaledToSize) {
            return originalImage
        }
        UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0.0)
        originalImage.draw(in: CGRect(x: 0, y: 0, width: scaledToSize.width, height: scaledToSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func startObservingDatabase () {
        print("here")
        databaseHandle = ref.child("markers").observe(.value, with: { (snapshot) in
            let json = try? JSON(arrayLiteral: snapshot.value!)
            for markerJSON in json?.array?.first?.array ?? [] {
                print("marker json \(markerJSON)")
                var marker = Marker()
                marker.markerPositionX = markerJSON["markerPositionX"].double
                marker.markerPositionY = markerJSON["markerPositionY"].double
                marker.text = markerJSON["text"].string
                marker.title = markerJSON["title"].string
                marker.type = markerJSON["type"].int
                self.showMarker(myMarker: marker)
            }
        })
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

extension MapViewController: GMSMapViewDelegate {
    
}
