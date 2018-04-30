//
//  Person.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: NSObject, Mappable {

    var id: String?
    var name: String?
    
    required init?(map: Map) {
        if(map.JSON["name"] == nil) { //error checking.. make sure map actually has desired values
            return nil
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}
