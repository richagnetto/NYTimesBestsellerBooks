//
//  BookDetailsViewController.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire
import AlamofireImage

//book details: title, author, description & links to Amazon & Review (if provided by the API)
class BookDetailsViewController: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthorName: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    @IBOutlet weak var bookAmazonLink: UIButton!
    @IBOutlet weak var bookReviewLink: UIButton!
    
    var bookDetails = Book()
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Book Details"
        let realm = RealmService.shared.realm
        
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No error detected")
        }
        
        self.bookTitle.text = bookDetails.bookname
        self.bookAuthorName.text = bookDetails.authorname
        self.bookDescription.text = bookDetails.desc
        
    }
    
    @IBAction func amazonButton(_ sender: Any) {
        if let url = URL(string: bookDetails.amazon_url) {
            UIApplication.shared.open(url, options: [:])
        }
        else {
            let alert = UIAlertController(title: "Oops!", message: "Amazon Product Link Unavailable", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func reviewButton(_ sender: Any) {
        if let url = URL(string: bookDetails.review) {
            UIApplication.shared.open(url, options: [:])
        }
        else {
            let alert = UIAlertController(title: "Oops!", message: "NYTimes Review Unavailable", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RealmService.shared.stopObservingErrors(in: self)
    }
    
}
