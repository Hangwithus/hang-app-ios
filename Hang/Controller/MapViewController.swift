//
//  MapViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Mapbox
import MessageUI

class MapViewController: UIViewController, MGLMapViewDelegate, MFMessageComposeViewControllerDelegate {

   
    let messageController = MFMessageComposeViewController()
    var mapViewPresented = false

    @IBOutlet weak var leaveBtn: UIButton!
    @IBOutlet weak var chatButton: SelectionButton!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var bottomContainer: GradientView!
    @IBOutlet weak var topContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
     
        chatButton.layer.cornerRadius = 26
        chatButton.transform = CGAffineTransform(translationX: 0, y: 200)
        leaveBtn.alpha = 0
        #if DEBUG
            if (NSClassFromString("XCTest") == nil) {
                mapView.showsUserLocation = true
            }
            else {
                mapView.showsUserLocation = false
            }
        #endif
        

    }
    
    @IBAction func leaveTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.leaveBtn.alpha = 0
            self.chatButton.transform = CGAffineTransform(translationX: 0, y: 127)
        }) { (_) in
            //animation is finished
            self.performSegue(withIdentifier: "showFriends", sender: self)
          
        }
        
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            messageController.body = "Let's Hang"
            messageController.recipients = ["11111111111"]
            messageController.messageComposeDelegate = self
            self.present(messageController, animated: true, completion: nil)
            
        }
        else
        {

            print("cant send dat shit")
        }
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mapViewPresented {
            
        } else {
            self.performSegue(withIdentifier: "showFriends", sender: self)
            mapViewPresented = true
        }
    
//        print("test")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        segue.destination.modalPresentationStyle = .overCurrentContext
        segue.destination.modalTransitionStyle = .crossDissolve
        if let friendsViewController = segue.destination as? FriendsUIViewController {
            friendsViewController.delegate = self
        }
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    messageController.dismiss(animated: true, completion: nil)
    }
    
}


extension MapViewController : FriendsUIViewControllerDelegate {
    func friendsDidDismiss() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.leaveBtn.alpha = 1
            self.chatButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (_) in
            //animation is finished
         
        }


    }
}
