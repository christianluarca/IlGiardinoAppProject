//
//  CartViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/25/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var totalBeforeTax: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var rewardPointsLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    var container: NSPersistentContainer?
    var cart: [NSManagedObject]? = []
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar title
        self.navigationItem.title = "Cart"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Book", size: 25)!]

        //Show Home button
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "icon-home"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(CartViewController.homeTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButtonItem]
        
        //Sign in prompt
        if defaults.bool(forKey: "signedIn") {
            signInButton.isHidden = true
            rewardPointsLabel.isHidden = true
        }
        else {
            signInButton.isHidden = false
            rewardPointsLabel.isHidden = false
        }
        
        //Orders table format
        ordersTable.rowHeight = 85
        ordersTable.layer.masksToBounds = true
        ordersTable.layer.borderColor = UIColor( red: 47/255, green: 61/255, blue: 60/255, alpha: 1.0 ).cgColor
        ordersTable.layer.borderWidth = 1.0
        
        updateCart()
        ordersTable.reloadData()
        updateTotal()
        
        //Setting back button font for next page to Avenir Heavy 25pt
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 25)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
    
    }

    @objc func homeTapped(sender:UIButton) {
        performSegue(withIdentifier: "showHome", sender: nil)
    }
    
    func updateTotal() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            var total: Double = 0
            for data in result as! [NSManagedObject] {
                let price = data.value(forKey: "price") as! Double
                let quantity = data.value(forKey: "quantity") as! Double
                total += (price * quantity)
            }
            totalBeforeTax.text = "$\(String(format:"%.2f", total))"
        } catch {
            print("Failed to retrieved object...")
        }
    }
    
    func updateCart() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        request.returnsObjectsAsFaults = false
        
        do {
            cart = try context.fetch(request) as? [NSManagedObject]
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//                print()
//                print(data)
//                print(data.value(forKey: "name"))
//                print(data.value(forKey: "price"))
//                print(data.value(forKey: "quantity"))
//                print()
//            }
        } catch {
            print("Failed to retrieved object...")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ordersTable.reloadData()
    }
    
    func updateOrder(_ row: Int,_ action: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            let order = result[row]
            switch action {
            case 0:
                //delete
                context.delete(order)
                try context.save()
            case 1:
                //increase
                let currentOrderQuantity = order.value(forKey: "quantity") as! Double
                order.setValue((currentOrderQuantity + 1), forKey: "quantity")
                try context.save()
            case 2:
                let currentOrderQuantity = order.value(forKey: "quantity") as! Double
                if currentOrderQuantity == 1 {
                    //PROMPT DELETING THE ORDER
                    return
                }
                order.setValue((currentOrderQuantity - 1), forKey: "quantity")
                try context.save()
            default:
                //do nothing
                print("object not updated")
            }
        } catch {
            print("Failed to retrieved object...")
        }
        updateCart()
        self.ordersTable.reloadData()
        updateTotal()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var sections = 0
    for _ in self.cart! {
        sections += 1
    }
    return sections
}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath as IndexPath) as! CartTableViewCell
    
//    let itemsInCategory = self.menu[indexPath.section].items
        let order = self.cart![indexPath.row]
        let name = order.value(forKey: "name") as! String
        let quantity = order.value(forKey: "quantity") as! Double
        let price = order.value(forKey: "price") as! Double
        
    // Use reference variable to set values of specified element of prototype cell
        cell.orderName.text = name
        cell.orderQuantity.text = String(format:"%.f",quantity)
        let adjustedPrice = price * quantity
        cell.orderPrice.text = "$\(String(format:"%.2f", adjustedPrice))"
    
    return cell
        
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = ordersTable.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }

        updateOrder(indexPath.row, 2)
        
    }
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = ordersTable.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }

        updateOrder(indexPath.row, 1)
    }
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = ordersTable.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }

        updateOrder(indexPath.row, 0)
    }
    
    // What happens when you tap on a row?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Remove highlight after tap.
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
