//
//  FriendsUIViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension UILabel {
    
    @IBInspectable var kerning: Float {
        get {
            var range = NSMakeRange(0, (text ?? "").count)
            guard let kern = attributedText?.attribute(kCTKernAttributeName as NSAttributedStringKey, at: 0, effectiveRange: &range),
                let value = kern as? NSNumber
                else {
                    return 0
            }
            return value.floatValue
        }
        set {
            var attText:NSMutableAttributedString
            
            if let attributedText = attributedText {
                attText = NSMutableAttributedString(attributedString: attributedText)
            } else if let text = text {
                attText = NSMutableAttributedString(string: text)
            } else {
                attText = NSMutableAttributedString(string: "")
            }
            
            let range = NSMakeRange(0, attText.length)
            attText.addAttribute(kCTKernAttributeName as NSAttributedStringKey, value: NSNumber(value: newValue), range: range)
            self.attributedText = attText
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



protocol FriendsUIViewControllerDelegate {
    func friendsDidDismiss()
    
    
}

class FriendsUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate : FriendsUIViewControllerDelegate?
    
    
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var hangButton: UIButton!
    @IBOutlet weak var hangButtonContainerView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var statusRing: UIImageView!
    //Time picker
    @IBOutlet weak var timeIcon: UIButton!
    @IBOutlet weak var timeIconBottomConstraint: NSLayoutConstraint!
    //Settings modal
    @IBOutlet weak var settingsPopup: UIView!
    @IBOutlet weak var settingsPopupYAxis: NSLayoutConstraint!
    @IBOutlet weak var logoutBtn: UIButton!
    //Friends modal
    @IBOutlet weak var friendsPopup: UIView!
    @IBOutlet weak var yourHangCode: UILabel!
    @IBOutlet weak var friendIDField: UITextField!
    @IBOutlet weak var emojiField: UITextField!
    @IBOutlet weak var customStatusField: UITextField!
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var createStatusBtn: UIButton!
    @IBOutlet weak var friendsPopupYAxis: NSLayoutConstraint!
    @IBOutlet weak var popupBackgroundButton: UIButton!
    
    

    //fake data
    var friendsAvailable : Array<Dictionary<String,String>> = placeholderFriends
    var friendsUnavailable : Array<Dictionary<String,String>> = placeholderFriendsUavailable
    //if a status is selected
    var isAvailable = false
    //the index path of the checked cell
    var selectedCells = Set<IndexPath>()
    
    //variables to hold the real data
    var users = [Users]()
    var availableUsers = [Users]()
    var unavailableUsers = [Users]()
    var thisUserData = Users()
    var canAddFriend = true
    var shouldFetch = true
    
    //Fonts
    let semiBoldLabel = UIFont(name: "Nunito-SemiBold", size: UIFont.labelFontSize)
    let semiBoldLabelSmall = UIFont(name: "Nunito-SemiBold", size: UIFont.smallSystemFontSize)
    let boldLabel = UIFont(name: "Nunito-Bold", size: UIFont.labelFontSize)
    let largeLabel = UIFont(name: "Nunito-Bold", size: 30)
    
    //Picker variables
    var pickerRowVariable = 0
    var timerRowVariable = 0
    var lastStatusSelected = 0
    let pickerView = UIPickerView()
    var rotationAngle: CGFloat!
    let width:CGFloat = 300
    let height:CGFloat = 300
    
    //boolean to determine whether to assign timer picker or status picker the delegates
    var showTimerPicker = false
    
    var userStatus = "Status Not Found"
    var userEmoji = "❓"
    //var currentGuy = ""
    
    var selectedPeople = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View
//        tableView.reloadData()
       UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)


        tableView.delegate = self
        tableView.dataSource = self
        //removes separator lines
        tableView.tableFooterView = UIView()
        //disable sticky headers
        let dummyViewHeight = CGFloat(58)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        
        if showTimerPicker == false {
            //Status Picker
            statusPicker.delegate  = self
            statusPicker.dataSource = self
        } else {
            //Time Picker
            //timePicker.delegate  = self
            //timePicker.dataSource = self
        }
        
        //Status picker rotation
        rotationAngle = -90 * (.pi/180)
        statusPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        statusRing.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        //tableview
        tableView.backgroundColor = UIColor.clear

        //pushes hang button below the view on load
        hangButtonContainerView.alpha = 0

        hangButton.layer.cornerRadius = 26
        hangButtonContainerView.clipsToBounds = true
        tableView.transform = CGAffineTransform(scaleX: 2, y: 2)
        tableView.alpha = 0
        hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 173)
        
        //Friends popup styling
        friendsPopup.layer.cornerRadius = 26
        friendsPopup.layer.masksToBounds = true
        createStatusBtn.layer.cornerRadius = 26
        createStatusBtn.layer.masksToBounds = true
        addFriendBtn.layer.cornerRadius = 26
        addFriendBtn.layer.masksToBounds = true
        emojiField.layer.cornerRadius = 16
        emojiField.layer.masksToBounds = true
        friendIDField.layer.cornerRadius = 16
        friendIDField.layer.masksToBounds = true
        customStatusField.layer.cornerRadius = 16
        customStatusField.layer.masksToBounds = true
        
        //Settings styling
        settingsPopup.layer.cornerRadius = 26
        settingsPopup.layer.masksToBounds = true
        
        
        //Keyboard dismissal
        self.hideKeyboardWhenTappedAround()
        
        //currentGuy = Auth.auth().currentUser?.uid ?? "uid not found"
        guard let tacoMan = Auth.auth().currentUser?.uid else{
            return
        }
        currentGuy = tacoMan
        var emojiStrings = [""]
        var emojiTextStrings = [""]
        //let userEmojiRef = Database.database().reference().child("users").child(currentGuy)
        Database.database().reference().child("users").child(currentGuy).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? NSDictionary  {
                print("in that dictionary dawg")
                emojiStrings = dictionary["emojiList"] as? [String] ?? ["","💻", "🍱", "🍻"]
                emojiTextStrings = dictionary["emojiTextList"] as? [String] ?? ["unavailable","working", "food", "beer"]
                print(emojiStrings)
                status = emojiStrings
                print(status)
                statusText = emojiTextStrings
                self.statusPicker.reloadAllComponents()
            }
            
        }, withCancel: nil)
        
        print("printing currentGuy: "+currentGuy)
        //currentGuy = String(currentGuy)
        fetchUser()
        //hangCodeTag.text = thisUserData.friendCode
    }
    
    override
    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        //adds alpha mask to tableview after proper layout is loaded
        addGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.tableView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.tableView.alpha = 1
    
        }) { (_) in
            //animation is finished
         
        }
        guard let tacoMan = Auth.auth().currentUser?.uid else{
            loggedIn = false
            return
        }
        currentGuy = tacoMan
        print("appeared")
        print("view did load")
    }
    
    //Setting modal
    
    @IBAction func settingsPressed(_ sender: Any) {
        settingsPopupYAxis.constant = 0
        UIView.animate(withDuration: 0.7, animations: {
            self.popupBackgroundButton.alpha = 0.9
        })
        UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        handleLogout()
        settingsPopupYAxis.constant = 800
        UIView.animate(withDuration: 0.7, animations: {
            self.popupBackgroundButton.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //Friends popup

    @IBAction func showFriendsPopup(_ sender: Any) {
        //Open popupg
        yourHangCode.text = thisUserData.friendCode
        friendsPopupYAxis.constant = 0
        UIView.animate(withDuration: 0.7, animations: {
            self.popupBackgroundButton.alpha = 0.9
        })
        UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
        print(popupBackgroundButton.alpha)
    }
    
    @IBAction func popupBGTouched(_ sender: Any) {
        //Close popup
        friendsPopupYAxis.constant = 800
        settingsPopupYAxis.constant = 800
        UIView.animate(withDuration: 0.7, animations: {
            self.popupBackgroundButton.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
        print("touched")
        emojiField.text = ""
        customStatusField.text = ""
        friendIDField.text = ""
    }
    
    @IBAction func addFriendButton(_ sender: Any) {
        //Close popup
        canAddFriend = true
        addFriend()
        friendsPopupYAxis.constant = 800
        UIView.animate(withDuration: 0.7, animations: {
            self.popupBackgroundButton.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
        emojiField.text = ""
        customStatusField.text = ""
        friendIDField.text = ""
    }
    
    @IBAction func createStatusButton(_ sender: Any) {
        //Close popup
        friendsPopupYAxis.constant = 800
        UIView.animate(withDuration: 0.7, animations: {
            self.popupBackgroundButton.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
        addStatus()
        print("Pressed create status")
        if statusAdded == true {
            statusPicker.reloadAllComponents()
            print("reloaded components")
        }
    }
    
    @objc func addStatus (){
        let emojiInput = emojiField.text
        let statusInput = customStatusField.text
        status.append(emojiInput!)
        statusText.append(statusInput!)
        //save the updated status array to the database
        //save the updated status text array to the database
        //go into picker view and have it load the statuses from the database -- or refresh it
        //when the user info is loading then pull the statuses from the database and plug them into the picker view
        let emojiDBUpdate = ["emojiList": status]
        let emojiTextDBUpdate = ["emojiTextList":statusText]
        
        let userRef = Database.database().reference().child("users").child(currentGuy)
        userRef.updateChildValues(emojiDBUpdate, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err!)
                return
            }
            print("updated the users number friends")
        })
        userRef.updateChildValues(emojiTextDBUpdate, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err!)
                return
            }
            print("updated the users number friends")
        })
        statusAdded = true
        print([statusInput])
    }
    
    //Time icon pressed
    @IBAction func timeIconPressed(_ sender: Any) {
        showTimerPicker = !showTimerPicker
        if showTimerPicker == true {
            statusRing.isHighlighted = false
            statusPicker.selectRow(timerRowVariable, inComponent: 0, animated: false)
        } else {
            statusPicker.selectRow(pickerRowVariable, inComponent: 0, animated: false)
            statusRing.isHighlighted = true
        }
        statusPicker.reloadAllComponents()
        print("Pressed time icon")
        print (showTimerPicker)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkIfUserIsLogeedIn()
        guard let tacoMan = Auth.auth().currentUser?.uid else{
            return
        }
        currentGuy = tacoMan
        Database.database().reference().child("users").child(currentGuy).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? NSDictionary  {
                print("in that dictionary dawg")
                var emojiStrings = dictionary["emojiList"] as? [String] ?? ["","💻", "🍱", "🍻"]
                var emojiTextStrings = dictionary["emojiTextList"] as? [String] ?? ["unavailable","working", "food", "beer"]
                print(emojiStrings)
                status = emojiStrings
                print(status)
                statusText = emojiTextStrings
                self.statusPicker.reloadAllComponents()
            }
            
        }, withCancel: nil)
        print("view will appear")
    }
    
    func checkIfUserIsLogeedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]  {
                    
                    self.navigationItem.title = dictionary["name"] as? String
                    
                }
                
            }, withCancel: nil)
        }
        
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        //presents login view
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
        perform(#selector(removeNavigationText), with: nil, afterDelay: 1)
        
    }
    
    @objc func removeNavigationText() {
        self.navigationItem.title = " "
    }
    
    //Picker code
    func numberOfComponents(in statusPicker: UIPickerView) -> Int {
        
        statusPicker.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        
        //Limit columns in picker view to 1
        return 1
    }
    
    func pickerView(_ statusPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRows = 0
        if showTimerPicker == false {
            //Return how many rows needed from data
            numberOfRows = status.count
        } else {
            numberOfRows = timeLeftArray.count
        }
        print(numberOfRows)
        return numberOfRows
    }
    
    func pickerView(_ statusPicker: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ statusPicker: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Check whether user is unavailable or available
        var values = ["available":"", "status":"", "emoji":""]
        if row == 0 && showTimerPicker == false {
            //Show the selector ring image if unavailable
            UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.statusRing.isHighlighted = false
                self.statusRing.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            }) { (_) in
                //animation is finished
            }

            //sets availability to false and removes checks from marked cells
            isAvailable = false
            let dateformatter = DateFormatter()
            
            dateformatter.dateStyle = DateFormatter.Style.none
            
            dateformatter.timeStyle = DateFormatter.Style.short
            
            let now = dateformatter.string(from: NSDate() as Date)
            print("this is now")
            print(now)
            values = ["available":"false", "status":"unavailable", "lastAvailable":now]
            selectedCells.removeAll()
        } else if row != 0 && showTimerPicker == false {
            lastStatusSelected = row
            values = ["available":"true", "status":statusText[row], "emoji":status[row]]
            //Show the selector ring image if unavailable
            isAvailable = true
            UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                    self.statusRing.isHighlighted = true
                self.statusRing.transform = CGAffineTransform(scaleX: 1, y: 1)

            }) { (_) in
                //animation is finished
            }
        } else {
            values = ["available":"true", "status":statusText[lastStatusSelected], "emoji":status[lastStatusSelected]]
        }
        
        if showTimerPicker == true {
            statusRing.isHighlighted = false
            timerRowVariable = row
        } else {
            //If status picker is showing then store current status row number into pickerRowVariable
            pickerRowVariable = row
            print(pickerRowVariable)
        }
        
        //if statement to set alpha of time Icon based on if available or not
        if isAvailable == true {
            timeIconBottomConstraint.constant = 30
            UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            timeIconBottomConstraint.constant = -100
            UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
            //add zero time
        }

        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
        let usersReference = Database.database().reference().child("users").child(currentGuy)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            //self.dismiss(animated: true, completion: nil)
            
            print("updated the status")
            
        })
        tableView.reloadData()
    }
    
    //Create Custom UI View for picker
    func pickerView(_ statusPicker: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        if showTimerPicker == false {
            let availabilityEmoji = UILabel()
            
            availabilityEmoji.frame = CGRect(x: 0, y: 0, width: width, height: 250)
            availabilityEmoji.textAlignment = .center
            
            if #available(iOS 11.0, *) {
                availabilityEmoji.font = UIFontMetrics.default.scaledFont(for: largeLabel!)
            } else {
                // Fallback on earlier versions
            }
            availabilityEmoji.text = status[row]
            
            let availabilityTitle = UILabel()
            availabilityTitle.textColor = UIColor.white
            availabilityTitle.frame = CGRect(x:0, y:20, width: width, height:height)
            availabilityTitle.textAlignment = .center
            //availabilityTitle.translatesAutoresizingMaskIntoConstraints = false
            //availabilityTitle.bottomAnchor.constraint(equalTo: UIView.topAnchor).isActive = true
            if #available(iOS 11.0, *) {
                availabilityTitle.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
            } else {
                // Fallback on earlier versions
            }
            availabilityTitle.text = statusText[row]
            
            view.addSubview(availabilityTitle)
            view.addSubview(availabilityEmoji)
        } else {
            let timeLeft = UILabel()
            
            timeLeft.frame = CGRect(x: 0, y: 0, width: width, height: 250)
            timeLeft.textAlignment = .center
            timeLeft.textColor = UIColor.white
            
            if #available(iOS 11.0, *) {
                timeLeft.font = UIFontMetrics.default.scaledFont(for: largeLabel!)
            } else {
                // Fallback on earlier versions
            }
            timeLeft.text = timeLeftArray[row]
            
            let timeDenom = UILabel()
            timeDenom.textColor = UIColor.white
            timeDenom.frame = CGRect(x:0, y:20, width: width, height:height)
            timeDenom.textAlignment = .center
            //availabilityTitle.translatesAutoresizingMaskIntoConstraints = false
            //availabilityTitle.bottomAnchor.constraint(equalTo: UIView.topAnchor).isActive = true
            if #available(iOS 11.0, *) {
                timeDenom.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
            } else {
                // Fallback on earlier versions
            }
            timeDenom.text = timeDenomArray[row]
            
            view.addSubview(timeDenom)
            view.addSubview(timeLeft)
        }
            //View rotation
            view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
            return view
    }
    
   //Table view code
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //define sections for when available
        if isAvailable == true {
            if section == 0 {
                //placeholder for current users status cell
                return 1
            } else if section == 1 {
               // return friendsAvailable.count
                return availableUsers.count

            } else if section == 2 {
                //return friendsUnavailable.count
                return unavailableUsers.count

            }

            //define sections for unavailable
        } else {
            if section == 0 {
                //return friendsAvailable.count
                return availableUsers.count

            }
            //return friendsUnavailable.count
            return unavailableUsers.count

        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isAvailable == true {
            //sets 3 sections for when available: current user status, available, and unavailable
            return 3
        } else {
            return 2
        }    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isAvailable == true && section == 1 {
            //sets height of section with no title to separate current user status and available status
            return 16
        }
        //normal height of a section with a title
        return 58
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //the first section will have a header
        //the third section can have a header only if the status is set to available
        //the second section cna have a header only if youre not available
        if section == 0 || (self.isAvailable && section == 2) || (self.isAvailable == false && section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
            //first section has available as header text, all others have unavailable
            cell.title.text = section == 0 ? "AVAILABLE" : "UNAVAILABLE"
            cell.title.kerning = 1
            
            return cell
        }
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let userAvailable = friendsAvailable[indexPath.row]
       // let userUnavailable = friendsUnavailable[indexPath.row]
        
     

        //set cells for available
        if isAvailable == true {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
                /*cell.name.text = "You"
                cell.info.text = "1hr left to Hang"
                cell.emoji.text = "🍻"*/
                cell.info.text = userStatus
                cell.emoji.text = userEmoji
                cell.name.text = "You"
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
                /*cell.name.text = userAvailable["name"]
                cell.info.text = userAvailable["distance"]
                cell.emoji.text = userAvailable["emoji"]
                cell.available.isHidden = true
                cell.checkAccessory.isHidden = false
                if selectedCells.contains(indexPath) {
                    cell.checkAccessory.isSelected = true
                } else {
                    cell.checkAccessory.isSelected = false
                }*/
              
                cell.name.text = availableUsers[indexPath.row].name
                cell.info.text = availableUsers[indexPath.row].status
                cell.emoji.text = availableUsers[indexPath.row].emoji
                cell.userId.text = availableUsers[indexPath.row].uid
                cell.available.isHidden = true
                cell.checkAccessory.isHidden = false
                if selectedCells.contains(indexPath){
                    cell.checkAccessory.isSelected = true
                }else{
                    cell.checkAccessory.isSelected = false
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendUnavailableCell") as! FriendsUnavailableTableViewCell
                //cell.name.text = userUnavailable["name"]
                //cell.info.text = userUnavailable["lastAvailable"]
                cell.name.text = unavailableUsers[indexPath.row].name
                cell.info.text = unavailableUsers[indexPath.row].lastAvailable
                return cell
            }
            //set cells for unavailable
        } else {
            if indexPath.section == 0 {
                /*let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
                cell.name.text = userAvailable["name"]
                cell.info.text = userAvailable["distance"]
                cell.emoji.text = userAvailable["emoji"]
                cell.available.isHidden = false
                cell.checkAccessory.isHidden = true

                return cell*/
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
                cell.name.text = availableUsers[indexPath.row].name
                cell.info.text = availableUsers[indexPath.row].status
                cell.emoji.text = availableUsers[indexPath.row].emoji
                cell.available.isHidden = false
                cell.checkAccessory.isHidden = true
                return cell
            } else {
                /*let cell = tableView.dequeueReusableCell(withIdentifier: "friendUnavailableCell") as! FriendsUnavailableTableViewCell
                cell.name.text = userUnavailable["name"]
                cell.info.text = userUnavailable["lastAvailable"]
                return cell*/
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendUnavailableCell") as! FriendsUnavailableTableViewCell
                cell.name.text = unavailableUsers[indexPath.row].name
                cell.info.text = unavailableUsers[indexPath.row].availability
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //cell selection for when available

     
        
        if isAvailable == true {
            //current user status cell
            if indexPath.section == 0 {
                
            } else if indexPath.section == 1 {
                //available friends cells
                print("cell tapped")
                let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
             
                if cell.checkAccessory.isSelected == true {
                    //if cell is checked, remove checkmark and cell index from selected cells set
                    cell.checkAccessory.isSelected = false
                    selectedCells.remove(indexPath)
                    selectedPeople = selectedPeople.filter{$0 != cell.userId.text!}
                    print(selectedPeople)
                    peopleToChill = selectedPeople
                    //selectedPeople.remove(at: indexPath)
                }else {
                    //if cell is unchecked, add checkmark and add cell to selected cells set
                    cell.checkAccessory.isSelected = true
                    selectedCells.insert(indexPath)
                    //selectedPeople.insert(at: indexPath, cell.userId)
                    selectedPeople.append(cell.userId.text!)
                    print(selectedPeople)
                    peopleToChill = selectedPeople
                }
                    UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                        //remove satus picker and display hang button if a cell is checked
                        if self.selectedCells.count > 0 {
                            self.hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: 220)
                            self.pickerContainerView.alpha = 0
                            self.hangButtonContainerView.alpha = 1

                        } else {
                            //dismiss hang button and display status picker when no cells are checked
                            self.pickerContainerView.alpha = 1
                            self.hangButtonContainerView.alpha = 0
                            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 173)

                        }
                        
                    }) { (_) in
                        //animation is finished
                    }
              
            } else {
             
            }
        } else {
            if indexPath.section == 0 {
                
            } else {
               
            }
        }
    }
    
    //rounded cell corners
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
            //Top Left Right Corners
            let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
            let shapeLayerTop = CAShapeLayer()
            shapeLayerTop.frame = cell.bounds
            shapeLayerTop.path = maskPathTop.cgPath
            
            //Bottom Left Right Corners
            let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
            let shapeLayerBottom = CAShapeLayer()
            shapeLayerBottom.frame = cell.bounds
            shapeLayerBottom.path = maskPathBottom.cgPath
            
            //All Corners
            let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 8.0, height: 8.0))
            let shapeLayerAll = CAShapeLayer()
            shapeLayerAll.frame = cell.bounds
            shapeLayerAll.path = maskPathAll.cgPath
            
            if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
            {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0)
            {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
            {
                cell.layer.mask = shapeLayerBottom
            }
        
    }
    
    @IBAction func hangPressed(sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.hangButtonContainerView.alpha = 0
            self.hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 173)
//            self.maskView.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.tableView.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.tableView.alpha = 0
            self.darkView.alpha = 0
            self.addBtn.alpha = 0
            self.settingsBtn.alpha = 0
            peopleToChill = [String]()
            peopleToChill = self.selectedPeople
        }) { (_) in
            //animation is finished
            self.dismiss(animated: true, completion: nil)
            self.delegate?.friendsDidDismiss()
            
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController
        {
            print("test")
            //View Controller Popped
        }
        else
        {
            print("test2")
            //New view controller pushed
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination
//        destination.transitioningDelegate = scaleTransition
//    }
    
//    @IBAction func dismissVC(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }

    //gradient alpha mask
    func addGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = maskView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor
        ]
        gradient.locations = [0.0, 0.0, 0.07, 0.8, 1.0, 1.0]
        maskView.layer.mask = gradient
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addFriend(){
        print("trying to call")
        print(canAddFriend)
        if(canAddFriend == true){
            guard let inputedFriendCode = friendIDField.text else{
                print("field is not valid")
                return
            }
            print(inputedFriendCode)
            let rootRef = Database.database().reference()
            let query = rootRef.child("users").queryOrdered(byChild: "friendCode")
            //query.observeOnce(.value){ (snapshot) in
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children.allObjects as! [DataSnapshot]{
                    if let value = child.value as? NSDictionary{
                        let friend = Users()
                        let key = child.key
                        var friendNumFriends = value["numFriends"] as? String ?? "0"
                        let friendFriendCode = value["friendCode"] as? String ?? "Friend Code not found"
                        
                        if(friendFriendCode == inputedFriendCode){
                            print("found the friend")
                            guard let currentGuy = Auth.auth().currentUser?.uid else{
                                print("you are not logged in or something went wrong")
                                return
                            }
                            let userQuery = rootRef.child("users").child(currentGuy)
                            var userNumFriends = self.thisUserData.numFriends
                            /*userQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                             if let userValue = snapshot.value as? NSDictionary{
                             userNumFriends = userValue["numFriends"] as? String ?? "0"
                             print("you have this many friends: ")
                             print(userValue["numFriends"])
                             }else{
                             return
                             }
                             })*/
                            print("done getting the friend value")
                            var ifriendNumFriends = (friendNumFriends as NSString).integerValue
                            //problem here
                            var iuserNumFriends  = (userNumFriends! as NSString).integerValue
                            ifriendNumFriends = ifriendNumFriends + 1
                            iuserNumFriends = iuserNumFriends + 1
                            print(ifriendNumFriends)
                            print(iuserNumFriends)
                            let sFriendNumFriends = "\(ifriendNumFriends)"
                            let sUserNumFriends = "\(iuserNumFriends)"
                            self.thisUserData.numFriends = sUserNumFriends
                            let userValues = [sUserNumFriends:key]
                            let friendValues = [sFriendNumFriends:currentGuy]
                            let userNumValues = ["numFriends":sUserNumFriends]
                            let friendNumValues = ["numFriends":sFriendNumFriends]
                            
                            let userFriendsListReference = rootRef.child("users").child(currentGuy).child("friendsList")
                            let friendFriendsListReference = rootRef.child("users").child(key).child("friendsList")
                            let userReference = rootRef.child("users").child(currentGuy)
                            let friendReference = rootRef.child("users").child(key)
                            //if(canAddFriend == true){
                            userFriendsListReference.updateChildValues(userValues, withCompletionBlock: { (err, ref) in
                                if err != nil {
                                    print(err!)
                                    return
                                }
                                print("added the users friend")
                            })
                            friendFriendsListReference.updateChildValues(friendValues, withCompletionBlock: { (err, ref) in
                                if err != nil {
                                    print(err!)
                                    return
                                }
                                print("added the friends friend")
                            })
                            userReference.updateChildValues(userNumValues, withCompletionBlock: { (err, ref) in
                                if err != nil{
                                    print(err!)
                                    return
                                }
                                print("updated the users number friends")
                            })
                            friendReference.updateChildValues(friendNumValues, withCompletionBlock: { (err, ref) in
                                if err != nil{
                                    print(err!)
                                    return
                                }
                                print("updated the friends number friends")
                            })
                            //}
                            self.shouldFetch = true
                        }else{
                            print("its not me!")
                        }
                    }else{
                        //return
                    }
                }
            })
        }
        canAddFriend = false
    }
    
    func fetchUser() {
        DispatchQueue.main.async { self.tableView.reloadData() }
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            //self.availableUsers.removeAll()
            //self.unavailableUsers.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = Users()
                    //let key = child.key
                    let key = child.key
                    let availability = value["available"] as? String ?? "availability"
                    //print("this is the availability")
                    // print(value["available"])
                    // print(availability)
                    let name = value["name"] as? String ?? "Name not found"
                    //let email = value["email"] as? String ?? "Email not found"
                    let status = value["status"] as? String ?? "Status not found"
                    let lastAvailable = value["lastAvailable"] as? String ?? "Last Seen not found"
                    let emoji = value["emoji"] as? String ?? "Emoji not found"
                    let time = value["time"] as? String ?? "Time Left not found"
                    let location = value["location"] as? String ?? "Location not found"
                    user.name = name
                    user.lastAvailable = lastAvailable
                    user.emoji = emoji
                    user.time = time
                    user.uid = child.key
                    user.location = location
                    //user.email = email
                    user.availability = availability
                    user.status = status
                    //self.users.append(user)
                    /*if(child.key == Auth.auth().currentUser?.uid){
                     self.thisUserData = user
                     }else if(user.availability == "true"){
                     //self.availableUsers.append(key)
                     self.availableUsers.append(user)
                     print("got that");
                     }else{
                     //self.unavailableUsers.append(key)
                     self.unavailableUsers.append(user)
                     }*/
                    //^^^^ Add this back in after I know that the user authentication is working
                    
                    if(key == currentGuy){
                        //print(userStatus)
                        //print(userEmoji)
                        self.userStatus = status
                        self.userEmoji = emoji
                        user.numFriends = value["numFriends"] as? String ?? "NumFriends not found"
                        user.friendCode = value["friendCode"] as? String ?? "Friend Code not found"
                        
                        var arr1 = value["friendsList"] as? NSArray ?? NSArray(objects: "")
                        print("arr1 array")
                        print(arr1)
                        var objCArray = NSMutableArray(array: arr1)
                        print("objcarray")
                        print(objCArray)
                        let swiftArray: [String] = objCArray.flatMap({ $0 as? String })
                        print("swiftArray")
                        print(swiftArray)
                        user.friendsList = swiftArray
                        print("this is the friends list")
                        print(user.friendsList)
                        /*if let swiftArray = objCArray as NSArray as? [String] {
                            user.friendsList = swiftArray
                            // Use swiftArray here
                            print("printing swift array")
                            print(swiftArray)
                        }else{
                            user.friendsList = [""]
                            print("you failed")
                        }*/
                        
                        
                        print("here is the friends list")
                        print(value["friendsList"])
                        print("and here is the users friends list")
                        print(user.friendsList)
                        
                        self.thisUserData = user
                        //if(self.shouldFetch == true){
                            self.fetchFriends()
                            self.shouldFetch = false
                        //}
                        return
                        //print(userStatus)
                        //print(self.userStatus)
                        //print(userEmoji)
                        // print(self.userEmoji)
                    }/*else{
                        
                        if(user.availability == "true"){
                            self.availableUsers.append(user)
                            //print("got available user")
                        }else{
                            self.unavailableUsers.append(user)
                            //print("got unaviable user")
                        }
                        //print("availableUsers --")
                        //print(self.availableUsers)
                        // print("unavailableUsers --")
                        DispatchQueue.main.async { self.tableView.reloadData() }
                        
                        //print(self.unavailableUsers)
                    }*/
                }
            }
        }
    }
    
    func fetchFriends(){
        DispatchQueue.main.async { self.tableView.reloadData() }
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        //query.observe(.value) { (snapshot) in
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            self.availableUsers.removeAll()
            self.unavailableUsers.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = Users()
                    let key = child.key
                    let availability = value["available"] as? String ?? "availability"
                    //print("this is the availability")
                    // print(value["available"])
                    // print(availability)
                    let name = value["name"] as? String ?? "Name not found"
                    //let email = value["email"] as? String ?? "Email not found"
                    let status = value["status"] as? String ?? "Status not found"
                    let lastAvailable = value["lastAvailable"] as? String ?? "Last Seen not found"
                    let emoji = value["emoji"] as? String ?? "Emoji not found"
                    let time = value["time"] as? String ?? "Time Left not found"
                    let location = value["location"] as? String ?? "Location not found"
                    user.name = name
                    user.lastAvailable = lastAvailable
                    user.emoji = emoji
                    user.time = time
                    user.uid = child.key
                    user.location = location
                    //user.email = email
                    user.availability = availability
                    user.status = status
                    for friend in self.thisUserData.friendsList! {
                        //print("trying to add that friend yo")
                        //print(friend)
                        if(key == friend){
                            if(user.availability == "true"){
                                self.availableUsers.append(user)
                                //print("got available user")
                            }else{
                                self.unavailableUsers.append(user)
                                //print("got unaviable user")
                            }
                            //print("availableUsers --")
                            //print(self.availableUsers)
                            // print("unavailableUsers --")
                            DispatchQueue.main.async { self.tableView.reloadData() }
                        }
                    }
                }
            }
        }, withCancel: nil)
    }

}
