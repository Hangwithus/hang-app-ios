//
//  AuthManager.swift
//  Hang
//
//  Created by Benjamin Hylak on 5/2/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import RxSwift

class AuthManager
{
    private (set) var currentUser : BehaviorSubject<User?>
    
    var ref: DatabaseReference!
    
    init()
    {
        ref = Database.database().reference()
        currentUser = BehaviorSubject<User?>(value: nil)
        
        //TODO look into chaining
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if(snapshot.hasChild(user!.uid)) //if user exists
                {
                    //map snapshot, update current user
                }
                else
                {
                    //create user from auth user object
                }
            })
        })
    }
    
    /**
     Send a phone verification code, and cache the result incase app closes
     
     - parameters
        - phoneNumber: Phone number to send the text to
     */
    func sendPhoneVerification(phoneNumber: String) -> Observable<Bool>
    {
        return Observable.create({ observer in
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let _ = error {
                    observer.onNext(false)
                }
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                
                observer.onNext(true)
            }
            
            return Disposables.create()
        })
    }
    
    func confirmSmsCode(code: String) -> Observable<Bool>
    {
        return Observable.create({ observer in
            
            let verificationId = self.getVerificationId()
            
            guard verificationId != nil
            else {
                observer.onNext(false)
                return Disposables.create ()
            }
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationId!,
                verificationCode: code)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let _ = error {
                    observer.onNext(false)
                }
              
                observer.onNext(true)
                
                //dont worry about handling the user here. AuthManager is already handling the auth state
            }
    
            return Disposables.create()
        })
    }
    
    /**
    
    */
    func verificationInProgress() -> Bool
    {
        let verificationID = getVerificationId()
        
        return verificationID != nil
    }
    
    private func getVerificationId() -> String?
    {
        return UserDefaults.standard.string(forKey: "authVerificationID")
    }
}
