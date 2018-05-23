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
import Firebase
import FirebaseDatabase

var peopleToChill = [String]()

var loggedIn = true
var grabbedStuff = false

class MapViewController: UIViewController, MGLMapViewDelegate, MFMessageComposeViewControllerDelegate {

   
    var messageController = MFMessageComposeViewController()
    var mapViewPresented = false
    //var currentGuy = ""
    //var peopleToChill = [String]()
    var phoneNumbers = [String]()
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
        
        guard let tacoMan = Auth.auth().currentUser?.uid else{
            loggedIn = false
            return
        }
        currentGuy = tacoMan

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
            messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.recipients = phoneNumbers
            messageController.body = "Let's Hang"
            //messageController.recipients = ["11111111111"]
            
            self.present(messageController, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        messageController.dismiss(animated: true, completion: nil)
    }
    
    /*func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        messageController.dismiss(animated: true, completion: nil)
    }*/
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mapViewPresented {
            
        } else {
            self.performSegue(withIdentifier: "showFriends", sender: self)
            mapViewPresented = true
        }
    
        print("test")
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
        if grabbedStuff == false{
            let location = mapView.userLocation?.location
            mapView.setCenter(CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!),zoomLevel: 11, animated: false)
            mapView.camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!), fromDistance: 2000, pitch: 0, heading: 0)
            if(loggedIn == true){
                guard let tacoMan = Auth.auth().currentUser?.uid else{
                    loggedIn = false
                    return
                }
                currentGuy = tacoMan
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
            grabbedStuff = true
        }
    }
    
    func grabUserLocations(){
        //print("grabbing")
        //print(peopleToChill)
        for person in peopleToChill{
            print(person)
            //let query = Database.database().reference().child("users").child(person)
            //query.observe(.value){ (snapshot) in
            Database.database().reference().child("users").child(person).observeSingleEvent(of: .value, with: { (snapshot) in
                print("observing")
                //for child in snapshot.children.allObjects as! [DataSnapshot]{
                    if(person != currentGuy){
                        print("not me")
                        if let value0 = snapshot.value as? NSDictionary{
                            print("im a dictionary")
                            var phoneNumber = value0["number"] as? String ?? "2393148826"
                            let name = value0["name"] as? String ?? "Name not found"
                            let status = value0["status"] as? String ?? "Status not found"
                            let emoji = value0["emoji"] as? String ?? "Emoji not found"
                            var check = 0
                            for pN in self.phoneNumbers {
                                if(pN == phoneNumber){
                                    check = check+1
                                }
                            }
                            print(self.phoneNumbers)
                            if(check == 0){
                                self.phoneNumbers.append(phoneNumber)
                            }
                            var availableUser = value0["available"] as? String ?? "Availability not found"
                            if(availableUser == "true"){
                                print("grabbing ttheir location")
                                let locationQuery = Database.database().reference().child("users").child(person).child("location")
                                locationQuery.observe(.value){(snapshot2) in
                                    if let value = snapshot2.value as? NSDictionary{
                                        print("the value is")
                                        print(value)
                                        var long = value["longitude"] as? Double ?? 0
                                        var lat = value["latitude"] as? Double ?? 0
                                    
                                        let annotation = MGLPointAnnotation()
                                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                        annotation.title = name
                                        annotation.subtitle = emoji + status
                                        self.mapView.addAnnotation(annotation)
                                        print("key: "+person)
                                        print(long)
                                        print(lat)
                                    }
                                }
                            }
                        }
                    //}
                }
            }, withCancel: nil)
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    messageController.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 32, height: 32)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            annotationView!.backgroundColor = UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 4
        layer.borderColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 8 : 4
        layer.add(animation, forKey: "borderWidth")
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
