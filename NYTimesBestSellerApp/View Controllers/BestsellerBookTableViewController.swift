//
//  BestsellerBookTableViewController.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/10/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BestsellerBookTableViewController: UIViewController {
    
    @IBOutlet weak var bestsellerTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var bookNames : Results<Book>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let realm = RealmService.shared.realm
        bestsellerTableView.delegate = self
        bestsellerTableView.dataSource = self
        
        //ensures that lists are sorted in the segment control by default
        
        if let value = UserDefaults.standard.value(forKey: "sortDefault"){
            let selectedIndex = value as! Int
            segmentedControl.selectedSegmentIndex = selectedIndex
            if selectedIndex == 0{
                self.bookNames = self.bookNames.sorted(byKeyPath: "rank", ascending: true)
            }
            else{
                // date
                self.bookNames = self.bookNames.sorted(byKeyPath: "weeks_on_list", ascending: true)
            }
        }
        notificationToken = realm.observe({ (notification, realm) in
            self.bestsellerTableView.reloadData()
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
    
    @IBAction func segmentSort(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "sortDefault")
        if sender.selectedSegmentIndex == 0{
            self.bookNames = self.bookNames.sorted(byKeyPath: "rank", ascending: true)
        }
        else{
            // date
            self.bookNames = self.bookNames.sorted(byKeyPath: "weeks_on_list", ascending: true)
        }
        self.bestsellerTableView.reloadData()
    }
    
}

extension BestsellerBookTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bestsellerBookCell") as? BookNameListCell else {
            return UITableViewCell()
        }
        let bookName = bookNames[indexPath.row]
        cell.configureBookNameListCell(with: bookName)
        return cell
    }
}

extension BestsellerBookTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = RealmService.shared.realm
        let predicate = NSPredicate(format: "bookname CONTAINS [c] %@", self.bookNames[indexPath.row].bookname)
        let bestseller = realm.objects(Book.self).filter(predicate).first
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookDetails") as! BookDetailsViewController? else { return }
        vc.bookDetails = bestseller!
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController!.pushViewController(vc, animated: true)
        print("Book Name Selected")
        bestsellerTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}
