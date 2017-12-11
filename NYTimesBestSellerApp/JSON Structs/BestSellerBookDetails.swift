//
//  BestSellerBookDetails.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation

struct BestSellerBookDetails: Decodable {
    let book_details: [BestSellerBookTitle]
    let list_name: String
    let amazon_product_url: String
    let reviews: [BestSellerBookReview]
    let rank: Int
    let weeks_on_list: Int
}
