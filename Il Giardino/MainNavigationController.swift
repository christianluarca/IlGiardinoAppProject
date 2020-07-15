//
//  NavigationController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/25/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import CoreData

class MainNavigationController: UINavigationController {
    
    var container: NSPersistentContainer!
    let delegateRef = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if container == nil {
            container = delegateRef.container
            print("Added container.")
        }
        
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
//        print("\nNAVIGATION: HERE'S THE FUCKING CONTAINER:",container,"\n")
//        performSegue(withIdentifier: "Home", sender: container)
        let homeView = HomeViewController()
        present(homeView, animated: false, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? HomeViewController {
            nextVC.container = container
//            print("\nSENDING:",container,"\n")
        }
    }
}
