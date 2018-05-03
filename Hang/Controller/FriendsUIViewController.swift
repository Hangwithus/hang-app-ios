//
//  FriendsUIViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

<<<<<<< HEAD
=======
//implements UILabel Kerning
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
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

class FriendsUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
  
<<<<<<< HEAD
    
    @IBOutlet weak var tableView: UITableView!
    var friends : Array<Dictionary<String,String>> = placeholderFriends
    var friendsUnavailable : Array<Dictionary<String,String>> = placeholderFriendsUavailable

    let sections = ["AVAILABLE", "UNAVAILABLE"]
    
    //Outlet for status picker
    @IBOutlet weak var statusPicker: UIPickerView!
    
    //Outlet for status ring
    @IBOutlet weak var statusRing: UIImageView!
    
    //Outlet for create status sheet
    @IBOutlet weak var createStatusButton: UIButton!
    
    //Outlet for create status sheet
    @IBAction func addButtonPress(_ sender: Any) {
    //Navigates to the create status controllers
    }
    
=======
    @IBOutlet weak var hangButton: UIButton!
    @IBOutlet weak var hangButtonContainerView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var tableView: UITableView!

    //fake data
    var friendsAvailable : Array<Dictionary<String,String>> = placeholderFriends
    var friendsUnavailable : Array<Dictionary<String,String>> = placeholderFriendsUavailable
    //if a status is selected
    var isAvailable = false
    //the index path of the checked cell

    var selectedCells = Set<IndexPath>()
    
    @IBOutlet weak var statusPicker: UIPickerView!
    
    @IBOutlet weak var statusRing: UIImageView!
    
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    //Fonts
    let semiBoldLabel = UIFont(name: "Nunito-SemiBold", size: UIFont.labelFontSize)
    let semiBoldLabelSmall = UIFont(name: "Nunito-SemiBold", size: UIFont.smallSystemFontSize)
    let boldLabel = UIFont(name: "Nunito-Bold", size: UIFont.labelFontSize)
    let largeLabel = UIFont(name: "Nunito-Bold", size: 30)
    
    //Picker variables
    var pickerRowVariable = 0
    let pickerView = UIPickerView()
    var rotationAngle: CGFloat!
    let width:CGFloat = 300
    let height:CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
<<<<<<< HEAD
        tableView.tableFooterView = UIView()
        
        //disable sticky headers
=======
        //removes separator lines
        tableView.tableFooterView = UIView()

>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        let dummyViewHeight = CGFloat(58)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        
        //Status Picker
        statusPicker.delegate  = self
        statusPicker.dataSource = self
        
        //Status picker rotation
        rotationAngle = -90 * (.pi/180)
        statusPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        //tableview
        tableView.backgroundColor = UIColor.clear
<<<<<<< HEAD
    }

    //Status picker code
    func numberOfComponents(in statusPicker: UIPickerView) -> Int {
        
        //Hides the seperator from the status picker view
=======

        //pushes hang button below the view on load
        hangButtonContainerView.alpha = 0
        hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 200)
        //radius of hang button
      
        hangButton.layer.cornerRadius = 26
        hangButtonContainerView.clipsToBounds = true
    }
    
    override
    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        //adds alpha mask to tableview after proper layout is loaded
        addGradient()
    }
    
    //picker code
    
    func numberOfComponents(in statusPicker: UIPickerView) -> Int {
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        statusPicker.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        
        //Limit columns in picker view to 1
        return 1
    }
    
    func pickerView(_ statusPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
<<<<<<< HEAD
        //Return how many rows needed for the picker from data
        return status.count
    }
    
    //Status picker height
=======
        //Return how many rows needed from data
        return status.count
    }
    
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    func pickerView(_ statusPicker: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
<<<<<<< HEAD
    //Status picker width
=======
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    func pickerView(_ statusPicker: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
<<<<<<< HEAD
    //Executes code depending on what row is selected in the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Check whether user is unavailable or available
        if row == 0 {
            //Show the selector ring image if unavailable
            statusRing.isHighlighted = false
        } else {
            //Show the selector ring image if unavailable
            statusRing.isHighlighted = true
        }
=======
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Check whether user is unavailable or available
      
        if row == 0 {
            //Show the selector ring image if unavailable
            statusRing.isHighlighted = false
            //sets availability to false and removes checks from marked cells
            isAvailable = false

            selectedCells.removeAll()
        } else {
            //Show the selector ring image if unavailable
            isAvailable = true
            statusRing.isHighlighted = true
        }

        tableView.reloadData()
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    }
    
    //Create Custom UI View for picker
    func pickerView(_ statusPicker: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
<<<<<<< HEAD
        
        //Create UI view for picker
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        //Creates availability emoji
        let availabilityEmoji = UILabel()
        availabilityEmoji.frame = CGRect(x: 0, y: 0, width: width, height: 250)
        availabilityEmoji.textAlignment = .center
        availabilityEmoji.text = status[row]
        
        //Checks and fixes deprecated font protocols
=======
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let availabilityEmoji = UILabel()
        
        availabilityEmoji.frame = CGRect(x: 0, y: 0, width: width, height: 250)
        availabilityEmoji.textAlignment = .center
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        if #available(iOS 11.0, *) {
            availabilityEmoji.font = UIFontMetrics.default.scaledFont(for: largeLabel!)
        } else {
            // Fallback on earlier versions
        }
<<<<<<< HEAD
        
        //Creates availability status
=======
        availabilityEmoji.text = status[row]
        
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        let availabilityTitle = UILabel()
        availabilityTitle.textColor = UIColor.white
        availabilityTitle.frame = CGRect(x:0, y:20, width: width, height:height)
        availabilityTitle.textAlignment = .center
<<<<<<< HEAD
        availabilityTitle.text = statusText[row]
        
        //Checks and fixes deprecated font protocols
=======
        //availabilityTitle.translatesAutoresizingMaskIntoConstraints = false
        //availabilityTitle.bottomAnchor.constraint(equalTo: UIView.topAnchor).isActive = true
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        if #available(iOS 11.0, *) {
            availabilityTitle.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
        } else {
            // Fallback on earlier versions
        }
<<<<<<< HEAD
        
        //Adds emoji and title subviews to status picker view
        view.addSubview(availabilityTitle)
        view.addSubview(availabilityEmoji)
        
        //Rotates parent status picker view
=======
        availabilityTitle.text = statusText[row]
        
        view.addSubview(availabilityTitle)
        view.addSubview(availabilityEmoji)
        
        //View rotation
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
    
   //Table view code
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
<<<<<<< HEAD
        if section == 0 {
            return friends.count
            
        }
        return friendsUnavailable.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        cell.title.text = self.sections[section]
        cell.title.kerning = 1
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userAvailable = friends[indexPath.row]
        let userUnavailable = friendsUnavailable[indexPath.row]

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
            cell.name.text = userAvailable["name"]
            cell.info.text = userAvailable["distance"]
            cell.emoji.text = userAvailable["emoji"]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendUnavailableCell") as! FriendsUnavailableTableViewCell
            cell.name.text = userUnavailable["name"]
            cell.info.text = userUnavailable["lastAvailable"]
            return cell
        }
    }
    
=======

        //define sections for when available
        if isAvailable == true {
            if section == 0 {
                //placeholder for current users status cell
                return 1
            } else if section == 1 {
                return friendsAvailable.count
            } else if section == 2 {
                return friendsUnavailable.count
            }

            //define sections for unavailable
        } else {
            if section == 0 {
                return friendsAvailable.count
                
            }
            return friendsUnavailable.count
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
        //sets table view section titles
        if section == 0 || (self.isAvailable && section == 2) || (self.isAvailable == false && section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
            cell.title.text = section == 0 ? "AVAILABLE" : "UNAVAILABLE"
            cell.title.kerning = 1
            
            return cell
        }
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userAvailable = friendsAvailable[indexPath.row]
        let userUnavailable = friendsUnavailable[indexPath.row]

        //set cells for available
        if isAvailable == true {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
                cell.name.text = "You"
                cell.info.text = "1hr left to Hang"
                cell.emoji.text = "🏖"
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
                cell.name.text = userAvailable["name"]
                cell.info.text = userAvailable["distance"]
                cell.emoji.text = userAvailable["emoji"]
                cell.available.isHidden = true
                cell.checkAccessory.isHidden = false
                if selectedCells.contains(indexPath) {
                    cell.checkAccessory.isSelected = true
                } else {
                    cell.checkAccessory.isSelected = false
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendUnavailableCell") as! FriendsUnavailableTableViewCell
                cell.name.text = userUnavailable["name"]
                cell.info.text = userUnavailable["lastAvailable"]
                return cell
            }
            //set cells for unavailable
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
                cell.name.text = userAvailable["name"]
                cell.info.text = userAvailable["distance"]
                cell.emoji.text = userAvailable["emoji"]
                cell.available.isHidden = false
                cell.checkAccessory.isHidden = true

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendUnavailableCell") as! FriendsUnavailableTableViewCell
                cell.name.text = userUnavailable["name"]
                cell.info.text = userUnavailable["lastAvailable"]
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

                }else {
                    //if cell is unchecked, add checkmark and add cell to selected cells set
                    cell.checkAccessory.isSelected = true
                    selectedCells.insert(indexPath)
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
                            self.hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 200)

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
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
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

<<<<<<< HEAD

   
  

=======
    //gradient alpha mask
    func addGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = maskView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor
        ]
        gradient.locations = [0.0, 0.0, 0.08, 0.8, 1.0, 1.0]
        maskView.layer.mask = gradient
        
    }
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
