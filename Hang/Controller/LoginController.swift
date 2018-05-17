//
//  LoginController.swift
//  hang
//
//  Created by Joe Kennedy on 4/15/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class LoginController: UIViewController, UITextFieldDelegate {
    
    let logoImageView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "hanganim")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play{ (finished) in
            // Do something after finished
        }
        return animationView
    }()
    
    let logoAnimationView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    //creates container view for inputs
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
        
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let numberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let numberSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00)
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 26
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Sign Up"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00)
        sc.layer.cornerRadius = 16
        //sc.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha:0)
        sc.layer.masksToBounds = true
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Uh-Oh", message: "Woops! are you sure thats your account?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("I'll try again", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.dismiss(animated: true, completion: nil)
            loggedIn = true
        }
        
    }
    
    @objc func handleLoginRegister() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
        
    }
    
    @objc func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let number = numberTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Uh-Oh", message: "Something went wrong. Double check the fields and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Try again", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated
            let ref = Database.database().reference(fromURL: "https://hang-8b734.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let friendCode = name+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))
            let stringUID: String = String(uid)
            let friendsListData = [
                "0": stringUID
                //"1": stringUID
            ]
            let locationData = [
                "longitude":"0",
                "latitude":"0"
            ]
            //let friendsList = [friendsListData]
            
            usersReference.setValue(["friendsList":friendsListData])
            usersReference.setValue(["location":locationData])
            usersReference.setValue(["emojiList":status])
            usersReference.setValue(["emojiTextList":statusText])
            let values = ["name": name, "email": email, "available":"false", "status":"status", "number": number, "friendCode":friendCode, "numFriends":"0", "emoji":"❤️", "time":"0m", "lastAvailable":"5-9-18_10:05"]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                
                print("saved user successfully into firebase db")
                let alert = UIAlertController(title: "YAY!", message: "You succesfully made account. Go ahead and login.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Awww Yaaa", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            })

            loggedIn = true
        })
    }
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of input container view
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 200
        
        //change height of name field
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        nameTextFieldHeightAnchor?.isActive = true
        
        //change height of email field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        //change height of number field
        numberTextFieldHeightAnchor?.isActive = false
        numberTextFieldHeightAnchor = numberTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        numberTextFieldHeightAnchor?.isActive = true
        
        //change height of password field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1
        numberSeparatorViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        view.backgroundColor = UIColor.white
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        numberTextField.delegate = self
        passwordTextField.delegate = self
        
        //adds subviews to main view
//        view.addSubview(logoImageView)
        view.addSubview(logoAnimationView)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        setupLogoAnimationView()
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -16).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupLogoAnimationView() {
        logoAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoAnimationView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: 0).isActive = true
        logoAnimationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoAnimationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        logoAnimationView.addSubview(logoImageView)
        
        logoImageView.leftAnchor.constraint(equalTo: logoAnimationView.leftAnchor).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: logoAnimationView.rightAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: logoAnimationView.topAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: logoAnimationView.bottomAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoAnimationView.widthAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoAnimationView.heightAnchor).isActive = true


    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var numberTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var nameSeparatorViewHeightAnchor: NSLayoutConstraint?
    var numberSeparatorViewHeightAnchor: NSLayoutConstraint?

    func setupInputsContainerView() {
        //adds x, y, width, and height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 200);inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(numberTextField)
        inputsContainerView.addSubview(numberSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4);nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorViewHeightAnchor = nameSeparatorView.heightAnchor.constraint(equalToConstant:1)
        nameSeparatorViewHeightAnchor?.isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        numberTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        numberTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        numberTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        numberTextFieldHeightAnchor = numberTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4);numberTextFieldHeightAnchor?.isActive = true
        
        numberSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        numberSeparatorView.topAnchor.constraint(equalTo: numberTextField.bottomAnchor).isActive = true
        numberSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        numberSeparatorViewHeightAnchor = numberSeparatorView.heightAnchor.constraint(equalToConstant:1)
        numberSeparatorViewHeightAnchor?.isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: numberSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 16).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    //    @objc func keyboardWillShow(sender: NSNotification) {
    //        self.view.frame.origin.y -= 100
    //    }
    //    @objc func keyboardWillHide(sender: NSNotification) {
    //        self.view.frame.origin.y += 100
    //    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc  func keyboardWillChange(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if nameTextField.isFirstResponder || emailTextField.isFirstResponder || passwordTextField.isFirstResponder || numberTextField.isFirstResponder{
                self.view.frame.origin.y = -100
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            numberTextField.becomeFirstResponder()
        } else if textField == numberTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
