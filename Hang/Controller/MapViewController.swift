//
//  MapViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Mapbox
import Firebase
import FirebaseDatabase

class MapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    var currentGuy = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        #if DEBUG
            if (NSClassFromString("XCTest") == nil) {
                mapView.showsUserLocation = true
            }
            else {
                mapView.showsUserLocation = false
            }
        #endif
        currentGuy = Auth.auth().currentUser?.uid ?? "uid not found"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "showFriends", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        segue.destination.modalPresentationStyle = .overCurrentContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        let location = mapView.userLocation?.location
        mapView.setCenter(CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!),zoomLevel: 15, animated: false)
        var query = Database.database().reference().child("users").child(currentGuy).child("location")
        let longvalues = ["longitude": location?.coordinate.longitude]
        let latvalues = ["latitude": location?.coordinate.latitude]
        grabUserLocations()
        query.updateChildValues(longvalues, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err!)
                return
            }
            //print("updated longitude")
        })
        query.updateChildValues(latvalues, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err!)
                return
            }
            //print("updated latitude")
        })
    }
    
    func grabUserLocations(){
        let query = Database.database().reference().child("users")
        query.observe(.value){ (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if(child.key != self.currentGuy){
                    let locationQuery = Database.database().reference().child("users").child(child.key).child("location")
                    locationQuery.observe(.value){(snapshot2) in
                        if let value = snapshot2.value as? NSDictionary{
                            print("the value is")
                            print(value)
                            var long = value["longitude"] as? Double ?? 0
                            var lat = value["latitude"] as? Double ?? 0
                            let annotation = MGLPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            annotation.title = "One of your friends"
                            annotation.subtitle = "quite a good friend"
                            self.mapView.addAnnotation(annotation)
                            print("key: "+child.key)
                            print(long)
                            print(lat)
                        }
                    }
                }
            }
        }
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
