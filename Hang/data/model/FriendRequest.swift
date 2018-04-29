//
//  FriendRequest.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation

public class FriendRequest
{
    var fromPerson: Person
    var toPerson: Person
    var time: Date
    
    var accepted: Bool?
    
    init(from: Person, to: Person) {
        
    }
    
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
