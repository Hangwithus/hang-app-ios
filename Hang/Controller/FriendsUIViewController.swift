//
//  FriendsUIViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

//extension UITableView {
//    func reloadData(with animation: UITableViewRowAnimation) {
//        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
//    }
//}

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
  
    
    @IBOutlet weak var hangButton: UIButton!
    @IBOutlet weak var hangButtonContainerView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var friendsAvailable : Array<Dictionary<String,String>> = placeholderFriends
    var friendsUnavailable : Array<Dictionary<String,String>> = placeholderFriendsUavailable

    var isAvailable = false
    
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
    let scaleTransition = ScaleTransition()


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
        hangButtonContainerView.alpha = 0
        hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 200)
        hangButton.layer.cornerRadius = 26
        hangButtonContainerView.clipsToBounds = true
    }
    
    override
    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradient()
        
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
            isAvailable = false
            statusRing.isHighlighted = false
            selectedCells.removeAll()
        } else {
            //Show the selector ring image if unavailable
            isAvailable = true
            statusRing.isHighlighted = true
        }
//        let range = NSMakeRange(0, self.tableView.numberOfSections)
//        let sections = NSIndexSet(indexesIn: range)
//        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        tableView.reloadData()
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
        if isAvailable == true {
            if section == 0 {
                return 1
            } else if section == 1 {
                return friendsAvailable.count
            } else if section == 2 {
                return friendsUnavailable.count
            }
            
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
            return 3
        } else {
            return 2
        }    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isAvailable == true && section == 1 {
            return 16
        }
        return 58    }
    
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
        
        if isAvailable == true {
            if indexPath.section == 0 {
                
            } else if indexPath.section == 1 {
                print("cell tapped")
                let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
                if cell.checkAccessory.isSelected == true {
                    cell.checkAccessory.isSelected = false
                    selectedCells.remove(indexPath)

                }else {
                    cell.checkAccessory.isSelected = true
                    selectedCells.insert(indexPath)
                }
                    UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                        if self.selectedCells.count > 0 {
                            self.hangButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: 220)
                            self.pickerContainerView.alpha = 0
                            self.hangButtonContainerView.alpha = 1

                        } else {
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
        print("hang")
//         performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
      
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination
//        destination.transitioningDelegate = scaleTransition
//    }
    
//    @IBAction func dismissVC(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }


    func addGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = maskView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor
        ]
        gradient.locations = [0.0, 0.0, 0.08, 0.8, 1.0, 1.0]
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
