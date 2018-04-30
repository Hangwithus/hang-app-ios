//
//  FriendRequest.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import ObjectMapper

public class FriendRequest: BaseMappable
{
    private (set) var toId: String?
    private (set) var fromId: String?
    
    //var time: Date
    var accepted: Bool?
    
    func hasResponse() -> Bool
    {
        return accepted != nil
    }
    
    func reject() {
        accepted = false
    }
    
    func accept() {
        accepted = true
    }
}

extension FriendRequest: StaticMappable
{
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return FriendRequest()
    }
    
    public func mapping(map: Map) {
        self.toId <- map["to"]
        self.fromId <- map["from"]
    }
}
