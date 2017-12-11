//
//  ListNameTableViewController.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ListNameTableViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var listNames : Results<BookList>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bestseller Lists"
        listTableView.delegate = self
        listTableView.dataSource = self
        let realm = RealmService.shared.realm
        
        notificationToken = realm.observe({ (notification, realm) in
            self.listTableView.reloadData()
        })
        
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No error detected")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
    }
    
}

extension ListNameTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListNameCell") as? BookListCell else {
            return UITableViewCell()
        }
        let listName = listNames[indexPath.row]
        cell.configureBookListCell(with: listName)
        return cell
    }
}

extension ListNameTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listName = self.convertToParameter(str: self.listNames[indexPath.row].listname)
        print("List Name: \(listName) Selected")
        let realm = RealmService.shared.realm
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookNameScreen") as! BestsellerBookTableViewController? else { return }
        let navController = UINavigationController(rootViewController: vc)
        let predicate = NSPredicate(format: "listname CONTAINS [c] %@", self.listNames[indexPath.row].listname)
        let bestsellers = realm.objects(Book.self).filter(predicate)
        if bestsellers.count == 0 {
            BooksAPIClient.sharedInstance().getListBestSellerNames(listName) { (success) in
                if success {
                    vc.bookNames = realm.objects(Book.self).filter(predicate)
                        //self.present(vc, animated: true, completion: nil)
                        //self.navigationController?.present(navController, animated: true, completion: nil)
                    self.navigationController!.pushViewController(vc, animated: true)
                    }
                else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "noData")
                    let navController = UINavigationController(rootViewController: vc!)
                    self.navigationController!.pushViewController(vc!, animated: true)
                    print("Error getting data")
                }
            }
        }
        else {
            print("data already present")
            vc.bookNames = bestsellers
            //self.present(vc, animated: true, completion: nil)
            //self.navigationController?.present(navController, animated: true, completion: nil)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        listTableView.deselectRow(at: indexPath, animated: true)
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }

}

//converts parameters to values acceptable by next API request URL
extension ListNameTableViewController {
    
    func convertToParameter(str: String) -> String{
        let param = str.lowercased().replacingOccurrences(of: " ", with: "-")
        return param
    }
    
}
