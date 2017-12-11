//
//  BooksAPIClient.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/9/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class BooksAPIClient: NSObject {
    
    let api_key = "9d57bf4736dc41ce9bd62d11cd148b16"
    let realm = RealmService.shared.realm
    
    
    override init() {
        super.init()
    }
    
    class func sharedInstance() -> BooksAPIClient {
        struct Singleton {
            static var sharedInstance = BooksAPIClient()
        }
        return Singleton.sharedInstance
    }
    
    func getListNames(_ completionHandlerForListNames: @escaping (_ success: Bool) -> Void) {
        let url = "http://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(api_key)"
        Alamofire.request(URL(string: url)!).responseJSON { (response) in
            guard let data = response.data else {
                print("result guard error")
                completionHandlerForListNames(false)
                return
            }
            do {
                let bookListDesc = try JSONDecoder().decode(BookListDescription.self, from: data)
                
                for type in bookListDesc.results{
                    RealmService.shared.create(BookList(listname: type.list_name))
                }
                
                completionHandlerForListNames(true)
            } catch {
                print("error")
                completionHandlerForListNames(false)
            }
        }
    }
    
    func getListBestSellerNames(_ list_name:String,_ completionHandlerForListBestSellerNames: @escaping (_ success: Bool) -> Void) {
        let url = "http://api.nytimes.com/svc/books/v3/lists.json?api-key=\(api_key)&list=\(list_name)"
        Alamofire.request(URL(string: url)!).responseJSON { (response) in
            guard let data = response.data else {
                print("result guard error")
                completionHandlerForListBestSellerNames(false)
                return
            }
            do {
                let bestSellerResults = try JSONDecoder().decode(BestSellerListResults.self, from: data)
                
                for book_detail in bestSellerResults.results{
                    var rev = ""
                    for book_rev in book_detail.reviews{
                        if book_rev.book_review_link != "" {
                            rev = book_rev.book_review_link
                        }
                        else if book_rev.sunday_review_link != "" {
                            rev = book_rev.sunday_review_link
                        }
                    }
                    for book_name in book_detail.book_details{
                        RealmService.shared.create(Book(listname: book_detail.list_name, bookname: book_name.title, authorname: book_name.author, desc: book_name.description, amazon_url: book_detail.amazon_product_url, review: rev, rank: book_detail.rank, weeks_on_list: book_detail.weeks_on_list))
                    }
                }
                
                completionHandlerForListBestSellerNames(true)
            } catch {
                print("error")
                completionHandlerForListBestSellerNames(false)
            }
        }
    }
}
