//
//  User.swift
//  hang
//
//  Created by Joe Kennedy on 4/17/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

class Users: NSObject {
    
    var name: String?
    var email: String?
    var availability: String?
    var status: String?
    var lastAvailable: String?
    var emoji: String?
    var location: String?
    var time: String?
    var numFriends: String?
    var friendCode: String?
    var friendsList: [String]?
    var uid:String?
}

var status = ["","💻", "🍱", "🍻"]
var statusText = ["unavailable","working", "food", "beer"]
var defaultstatus = ["","💻", "🍱", "🍻"]
var defaultstatusText = ["unavailable","working", "food", "beer"]
var statusAdded = false


var timeLeftArray = ["∞","1","2","3"]
var timeDenomArray = ["","Hour","Hours","Hours"]
