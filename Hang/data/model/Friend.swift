//
//  Friend.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import ObjectMapper

class Friend: Person {
    var location: String? //TODO -- replace with lat/long object
    var lastSeen: Date?
    var status: String?
    var emoji: String?
    
    //convert object from json
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        //map any friend specific things
        location <- map["location"]
        lastSeen <- map["last_seen"]
        status <- map["status"]
        emoji <- map["emoji"]
    }
}
