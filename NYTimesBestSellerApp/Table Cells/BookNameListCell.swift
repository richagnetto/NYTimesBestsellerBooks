//
//  BookNameListCell.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import UIKit

class BookNameListCell: UITableViewCell {
    
    @IBOutlet weak var bookName: UILabel!
    
    func configureBookNameListCell(with book: Book) {
        bookName.text = book.bookname
    }
}

