//
//  UserManager.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class UserManager
{
    private(set) var currentUser: BehaviorSubject<User?>
    
    init() {
        currentUser = BehaviorSubject<User?>(value: nil)
        
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.currentUser.onNext(user) //map user to a HangUser here
        });
    }
    
    func newUser(withEmail email:String, password: String)
    {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            /** do create new user **/
            
        }
    }
    
    /*Takes a user, makes sure it's the same as the currently auth'd user, and updates anything in the object that's changed*/
    func updateUser(user:User)
    {
        
    }
    
    /* Log Out */
    func doLogOut()
    {
        
    }
}
