//
//  HangUser.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrentUser: Friend {
    
    var incomingFriendRequests: [FriendRequest]?
    var outgoingFriendRequests: [FriendRequest]?
    
    required init?(map: Map) {
        //do error checking as necessary
    }
    
    func setName(newName: String)
    {
        //self.name = newName
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.incomingFriendRequests <- Mapper<FriendRequest>().mapArray(JSONArray: map["incoming_friend_requests"])
    }
}
