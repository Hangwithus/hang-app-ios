//
//  LoginViewController.swift
//  Hang
//
//  Created by Joe Kennedy on 5/2/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let scaleTransition = ScaleTransition()

    @IBOutlet weak var getStarted: SelectionButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getStarted.layer.cornerRadius = 26
        getStarted.transform = CGAffineTransform(translationX: 0, y: 200)
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.getStarted.transform = CGAffineTransform(translationX: 0, y: 0)
            
            
        }) { (_) in
            //animation is finished
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = scaleTransition
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
