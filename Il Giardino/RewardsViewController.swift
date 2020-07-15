//
//  RewardsViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/19/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rewardsButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
        
        self.navigationItem.title = "Rewards"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Book", size: 25)!]
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 25)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
        //check if user has enough reward points to claim a reward
    }
    
    @IBAction func rewardsButtonPressed(_ sender: UIButton) {
    }
    @IBAction func signInButtonPressed(_ sender: UIButton) {
    }
    
    func updateDisplay() {
        if defaults.bool(forKey: "signedIn") {
            lineLabel.text = "Earn reward points with every order!"
            signInButton.isHidden = true
            rewardsButton.isEnabled = true
            rewardsButton.backgroundColor = UIColor(red: 87.0/255.0, green: 114.0/255.0, blue: 111.0/255.0, alpha: 1.0)
            
        }
        else {
            lineLabel.text = "            to earn reward points!"
            signInButton.isHidden = false
            rewardsButton.isEnabled = false
            rewardsButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }

}
