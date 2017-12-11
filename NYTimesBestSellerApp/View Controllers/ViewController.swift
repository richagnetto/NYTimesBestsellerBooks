//
//  ViewController.swift
//  NYTimesBestSellerApp
//
//  Created by Richa Netto on 12/9/17.
//  Copyright © 2017 Richa Netto. All rights reserved.
//

import UIKit
import RealmSwift

//display an initial screen with a button that taps to give the list_names
class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.titleLabel?.numberOfLines = 0
        startButton.titleLabel?.textAlignment = .center
        
    }
 
    @IBAction func buttonTapped(_ sender: Any) {
        let realm = RealmService.shared.realm
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "listNameScreen") as! ListNameTableViewController? else { return }
        let navController = UINavigationController(rootViewController: vc) 
        if realm.objects(BookList.self).count == 0 {
            BooksAPIClient.sharedInstance().getListNames() { (success) in
                if success {
                    vc.listNames = realm.objects(BookList.self)
                    print("listnames asigned")
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "noData")
                    let navController = UINavigationController(rootViewController: vc!)
                    self.navigationController!.pushViewController(vc!, animated: true)
                    print("Error getting data")
                }
            }
        } else {
            print("data already present")
            vc.listNames = realm.objects(BookList.self)
            self.navigationController!.pushViewController(vc, animated: true)

        }
    }
    
}

