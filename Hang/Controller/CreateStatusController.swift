import UIKit

class CreateStatusController: UIViewController,UIAlertViewDelegate, UITextFieldDelegate {
    
    var users = [Users]()
    
<<<<<<< HEAD
    //closure for create status button
=======
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    let emojiField: UITextField = {
        let emojiTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        emojiTextField.placeholder = "Enter an emoji"
        emojiTextField.font = UIFont.systemFont(ofSize: 15)
        emojiTextField.borderStyle = UITextBorderStyle.roundedRect
        emojiTextField.autocorrectionType = UITextAutocorrectionType.no
        emojiTextField.keyboardType = UIKeyboardType.default
        emojiTextField.returnKeyType = UIReturnKeyType.done
        emojiTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        emojiTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        return emojiTextField
    }()
    
<<<<<<< HEAD
    //closure for create status button
=======
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    let statusField: UITextField = {
        let statusTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        statusTextField.placeholder = "availability title"
        statusTextField.font = UIFont.systemFont(ofSize: 15)
        statusTextField.borderStyle = UITextBorderStyle.roundedRect
        statusTextField.autocorrectionType = UITextAutocorrectionType.no
        statusTextField.keyboardType = UIKeyboardType.default
        statusTextField.returnKeyType = UIReturnKeyType.done
        statusTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        statusTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        return statusTextField
    }()
    
<<<<<<< HEAD
    //closure function for create status button
=======
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    let createStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00)
        button.setTitle("Create status", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 26
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
<<<<<<< HEAD
        //Sets the button target
        button.addTarget(self, action: #selector(addStatus), for: .touchUpInside)
=======
        
        button.addTarget(self, action: #selector(addStatus), for: .touchUpInside)
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        view.backgroundColor = UIColor.white
        
        //Create navigation
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Cancel", style: .plain, target: self, action: #selector(handleHome))
        self.navigationItem.title = "Add Status"
        self.navigationController?.navigationBar.titleTextAttributes = [ kCTFontAttributeName: UIFont(name: "Nunito-Bold", size: 17)!] as [NSAttributedStringKey : Any]
        
        //Instantiate emoji and status fields
        emojiField.delegate = self
        statusField.delegate = self
        
        //Adds the text field and buttons to the screens view
        self.view.addSubview(emojiField)
        self.view.addSubview(statusField)
        self.view.addSubview(createStatusButton)
        
        //Calls the layout constraints for the field items
=======
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Cancel", style: .plain, target: self, action: #selector(handleHome))
        self.navigationItem.title = "Add Status"
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ kCTFontAttributeName: UIFont(name: "Nunito-Bold", size: 17)!] as [NSAttributedStringKey : Any]
        emojiField.delegate = self
        self.view.addSubview(emojiField)
        
        statusField.delegate = self
        self.view.addSubview(statusField)
        
        self.view.addSubview(createStatusButton)
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        setupLayout()
    }
    
    func setupLayout() {
<<<<<<< HEAD
        
        //Enable programmatic autolayout
        emojiField.translatesAutoresizingMaskIntoConstraints = false
        statusField.translatesAutoresizingMaskIntoConstraints = false
        createStatusButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Set constraints for emoji text field, status text field and create status button
=======
        emojiField.translatesAutoresizingMaskIntoConstraints = false
        statusField.translatesAutoresizingMaskIntoConstraints = false
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        emojiField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        emojiField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        statusField.topAnchor.constraint(equalTo: emojiField.topAnchor, constant: 50).isActive = true
        statusField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        emojiField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        statusField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
<<<<<<< HEAD
=======

        
        createStatusButton.translatesAutoresizingMaskIntoConstraints = false
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        createStatusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createStatusButton.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 16).isActive = true
        createStatusButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        createStatusButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    @objc func addStatus() {
<<<<<<< HEAD
        //Adds the status to the static data array containing user statuses
=======
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        let emojiInput = emojiField.text
        let statusInput = statusField.text
        status.append(emojiInput!)
        statusText.append(statusInput!)
        statusAdded = true
<<<<<<< HEAD
    }
    
    //Takes user to the home screen when called
    @objc func handleHome() {
        //Dismisses the create status screen to show home screen
        self.dismiss(animated: true, completion: nil)
=======
//        print(emojiInput)
//        print(statusInput)
        print([status])
        
        
    }
    
    
    @objc func handleHome() {
        
        self.dismiss(animated: true, completion: nil)
        
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }
    
<<<<<<< HEAD
=======
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
