//
//  FriendsUIViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

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
        tableView.tableFooterView = UIView()
        
        //disable sticky headers
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
    }

    //Status picker code
    func numberOfComponents(in statusPicker: UIPickerView) -> Int {
        
        //Hides the seperator from the status picker view
        statusPicker.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        
        //Limit columns in picker view to 1
        return 1
    }
    
    func pickerView(_ statusPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //Return how many rows needed for the picker from data
        return status.count
    }
    
    //Status picker height
    func pickerView(_ statusPicker: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    //Status picker width
    func pickerView(_ statusPicker: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
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
    }
    
    //Create Custom UI View for picker
    func pickerView(_ statusPicker: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //Create UI view for picker
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        //Creates availability emoji
        let availabilityEmoji = UILabel()
        availabilityEmoji.frame = CGRect(x: 0, y: 0, width: width, height: 250)
        availabilityEmoji.textAlignment = .center
        availabilityEmoji.text = status[row]
        
        //Checks and fixes deprecated font protocols
        if #available(iOS 11.0, *) {
            availabilityEmoji.font = UIFontMetrics.default.scaledFont(for: largeLabel!)
        } else {
            // Fallback on earlier versions
        }
        
        //Creates availability status
        let availabilityTitle = UILabel()
        availabilityTitle.textColor = UIColor.white
        availabilityTitle.frame = CGRect(x:0, y:20, width: width, height:height)
        availabilityTitle.textAlignment = .center
        availabilityTitle.text = statusText[row]
        
        //Checks and fixes deprecated font protocols
        if #available(iOS 11.0, *) {
            availabilityTitle.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
        } else {
            // Fallback on earlier versions
        }
        
        //Adds emoji and title subviews to status picker view
        view.addSubview(availabilityTitle)
        view.addSubview(availabilityEmoji)
        
        //Rotates parent status picker view
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
    
   //Table view code
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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


   
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
