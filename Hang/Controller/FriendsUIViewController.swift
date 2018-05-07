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

    //fake data
    var friendsAvailable : Array<Dictionary<String,String>> = placeholderFriends
    var friendsUnavailable : Array<Dictionary<String,String>> = placeholderFriendsUavailable
    //if a status is selected
    var isAvailable = false
    //the index path of the checked cell

    var selectedCells = Set<IndexPath>()
    
    @IBOutlet weak var statusPicker: UIPickerView!
    
    @IBOutlet weak var statusRing: UIImageView!
    
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
    
    //view transition


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
        
        //Status Picker
        statusPicker.delegate  = self
        statusPicker.dataSource = self
        
        //Status picker rotation
        rotationAngle = -90 * (.pi/180)
        statusPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        //tableview
        tableView.backgroundColor = UIColor.clear

        //pushes hang button below the view on load
        hangButtonContainerView.alpha = 0

        hangButton.layer.cornerRadius = 26
        hangButtonContainerView.clipsToBounds = true
        tableView.transform = CGAffineTransform(scaleX: 2, y: 2)
        tableView.alpha = 0
        hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 173)

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
    }
    
    //picker code
    
    func numberOfComponents(in statusPicker: UIPickerView) -> Int {
        
        statusPicker.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        
        //Limit columns in picker view to 1
        return 1
    }
    
    func pickerView(_ statusPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //Return how many rows needed from data
        return status.count
    }
    
    func pickerView(_ statusPicker: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ statusPicker: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
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

        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)

    }
    
    //Create Custom UI View for picker
    func pickerView(_ statusPicker: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
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

}
