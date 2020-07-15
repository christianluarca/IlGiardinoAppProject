//
//  ViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/9/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class HomeViewController: UIViewController {
    
    //Button references
    @IBOutlet weak var rewardsButton: UIButton!
    @IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!

    var container: NSPersistentContainer!
    
    let delegateRef = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if container == nil {
            container = delegateRef.container
        }
        
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        self.navigationItem.title = "Il Giardino"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Book", size: 25)!]
        
        //Hide the back button on the home page
        navigationItem.hidesBackButton = true
        
        //Set background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "tabletop")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        //Navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 114.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        
        //Show cart button
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "icon-cart"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(HomeViewController.cartTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButtonItem]
        
        //Setting back button font for next page to Avenir Heavy 25pt
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 25)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
    }

    
    
    //Set navigation bars status elements (carrier, time, battery) to black
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        
        rewardsButton.layer.borderWidth = 1
        reorderButton.layer.borderWidth = 1
        accountButton.layer.borderWidth = 1
    }
    
    //Stop animations when using the back button
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(false)
    }
    //Stop animations when using the back button continued
    override func viewDidDisappear(_ animated: Bool) {
        UIView.setAnimationsEnabled(false)
    }

    @objc func cartTapped(sender:UIButton) {
        performSegue(withIdentifier: "showCart", sender: nil)
    }
    
    //Override status elements to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func rewardsButtonPressed(_ sender: UIButton) {
    }
    @IBAction func reorderButtonPressed(_ sender: UIButton) {
    }
    @IBAction func accountButtonPressed(_ sender: UIButton) {
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? MenuTableViewController {
            nextVC.container = container
        }
        if let nextVC = segue.destination as? LoginRegistrationViewController {
            nextVC.container = container
        }
    }
//        let url = URL(string: "https://connect.squareup.com/v2/customers?Authorization=Bearer EAAAEPQw2Oveuz-c2exVhwaU9oWkVGUlEdp0LqO1eDkfNfq6M7LDoRUhaN6NVRCV&Accept=application/json")!
//        var request = URLRequest(url: url)
//        Alamofire.request(url)
    
}
