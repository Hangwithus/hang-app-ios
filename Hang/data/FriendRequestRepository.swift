//
//  FriendRequestRepository.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import RxSwift

class FriendRequestRepository {
    init() {
        //stub
    }
    
    func add(friendRequest: FriendRequest)
    {
        //verify that sender is auth'd user
    }
    
    func remove(friendRequest: FriendRequest)
    {
        
    }
    
    func update(friendRequest: FriendRequest)
    {
        
    }
    
    func getFriendRequests(userId: String) -> Observable<[FriendRequest]>?
    {
        return nil //STUB -- should remove optional type form return value
    }
    
    func getFriendRequests(person: Person)
    {
        
    }
}
