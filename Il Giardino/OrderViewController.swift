//
//  OrderViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 5/16/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import CoreData

class OrderViewController: UIViewController {

    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var cardInfoLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var container: NSPersistentContainer?
    var cart: [NSManagedObject]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Checkout"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Book", size: 25)!]
        
        updateTotal()
    }

    
    @IBAction func addCardButtonPressed(_ sender: UIButton) {
    }
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
    }
    
    func updateTotal() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            var subtotal: Double = 0
            for data in result as! [NSManagedObject] {
                let price = data.value(forKey: "price") as! Double
                let quantity = data.value(forKey: "quantity") as! Double
                subtotal += (price * quantity)
            }
            subtotalLabel.text = "$\(String(format:"%.2f", subtotal))"
            let taxRate = 0.095
            let taxValue = subtotal * taxRate
            taxLabel.text = "$\(String(format:"%.2f", taxValue))"
            let total = subtotal + taxValue
            totalLabel.text = "$\(String(format:"%.2f", total))"
            
        } catch {
            print("Failed to retrieved object...")
        }
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
