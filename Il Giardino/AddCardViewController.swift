//
//  AddCardViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 5/1/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import SquareInAppPaymentsSDK

class AddCardViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCardEntryForm()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddCardViewController: SQIPCardEntryViewControllerDelegate {
    
    func returnToPreviousView() {
        for _ in 0...2 {
            navigationController?.popViewController(animated: false)
        }
    }
    
    func showCardEntryForm() {
        let theme = SQIPTheme()
        
        //Customize the card payment form
        theme.tintColor = UIColor(red: 87.0/255.0, green: 114.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        theme.saveButtonTitle = "Submit"
        
        //Set cancel button
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 25)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
        theme.cancelButton = backButton
        
        //Get Square pre-generated view controller
        let cardEntryForm = SQIPCardEntryViewController(theme: theme)
        cardEntryForm.delegate = self
        
        //Push to top of navigation controller stack
        let navigationController = self.navigationController
        navigationController?.pushViewController(cardEntryForm, animated: true)
    }
    
    // MARK: - SQIPCardEntryViewControllerDelegate
    
    //Currently only serving the purpose of the cancel button
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController,
                                 didCompleteWith status: SQIPCardEntryCompletionStatus) {
        returnToPreviousView()
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController,
                                 didObtain cardDetails: SQIPCardDetails,
                                 completionHandler: @escaping (Error?) -> Void) {
        // Implemented in step 6.
        print("Obtained!")
//        print(cardDetails.nonce)
        defaults.set(cardDetails.nonce, forKey: "nonce")
        
        print(defaults.value(forKey: "nonce") as! String)
        
        returnToPreviousView()
    }
}
