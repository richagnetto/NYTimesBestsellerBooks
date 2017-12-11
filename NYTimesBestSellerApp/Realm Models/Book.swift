//
//  Book.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Book: Object {
    
    dynamic var listname: String = ""
    dynamic var bookname: String = ""
    dynamic var authorname: String = ""
    dynamic var desc: String = ""
    dynamic var amazon_url: String = ""
    dynamic var review: String = ""
    dynamic var rank: Int = 0
    dynamic var weeks_on_list: Int = 0
    dynamic var book_image: String = ""
    
    convenience init(listname: String, bookname: String, authorname: String, desc: String, amazon_url: String, review: String, rank: Int, weeks_on_list: Int) {
        self.init()
        self.listname = listname
        self.bookname = bookname
        self.authorname = authorname
        self.desc = desc
        self.amazon_url = amazon_url
        self.review = review
        self.rank = rank
        self.weeks_on_list = weeks_on_list
    }
}
