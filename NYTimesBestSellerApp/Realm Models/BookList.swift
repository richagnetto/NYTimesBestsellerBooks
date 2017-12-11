//
//  BookList.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class BookList: Object {
    
    dynamic var listname: String = ""
    
    convenience init(listname: String) {
        self.init()
        self.listname = listname
    }
}
