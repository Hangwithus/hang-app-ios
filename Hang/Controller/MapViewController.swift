//
//  MapViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
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
