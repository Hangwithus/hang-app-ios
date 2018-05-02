//
//  PersonRepository.swift
//  Hang
//
//  Created by Benjamin Hylak on 4/28/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import Foundation
import RxSwift

class PersonRepository
{
    func searchForPeople(name: String)
    {
        //stub
    }
    
    func searchForPeople(phoneNumber: String)
    {
        //stub
    }
    
    func getPerson(id: String) -> Observable<Friend?> {
        return Observable<Friend?>.create({ (observer) -> Disposable in
            //stub
            
            return Disposables.create()
        })
    }
    
    func getFriend(id: String) -> Observable<Friend?> {
        return Observable<Friend?>.create({ (observer) -> Disposable in
            //stub
            
            return Disposables.create()
        })
    }
}
