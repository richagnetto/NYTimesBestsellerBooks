//
//  BookListCell.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import UIKit

class BookListCell: UITableViewCell {
    
    @IBOutlet weak var listLabel: UILabel!
    
    func configureBookListCell(with bookList: BookList) {
        listLabel.text = bookList.listname
    }
}
