//
//  SelectedItemViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/12/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import CoreData

class SelectedItemViewController: UIViewController {

    var container: NSPersistentContainer?
    
//    var delegateReference = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    
    let defaults = UserDefaults.standard
    
    var selectedItem: [String: Any] = [:]
    var quantity: Double = 1
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "icon-cart"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(SelectedItemViewController.cartTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButtonItem]

//        //Set background
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "tabletop")?.draw(in: self.view.bounds)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.view.backgroundColor = UIColor(patternImage: image)
        
        let item = self.selectedItem
        let priceString:String = String(format:"%.2f", item["price"] as! Double)
        
        itemImg.layer.borderWidth = 1
        itemName.text = item["name"] as? String
        itemDesc.text = item["desc"] as? String
        itemImg.image = item["img"] as? UIImage
        itemPrice.text = "$\(priceString)"
        
        //Setting back button font for next page to Avenir Heavy 25pt
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 25)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func cartTapped(sender:UIButton) {
        performSegue(withIdentifier: "showCart", sender: nil)
    }
    
    func addOrderToCart() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Order", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        newEntity.setValue(selectedItem["name"] as! String, forKey: "name")
        newEntity.setValue(selectedItem["price"] as! Double, forKey: "price")
        newEntity.setValue(quantity, forKey: "quantity")
        do {
            try context.save()
            print("Saved!")
        } catch {
            print("Failed saving...")
        }
        
        //Alert that item was added to cart
        let name = selectedItem["name"] as! String
        let quantity = String(format:"%.f",self.quantity)
        let alertController = UIAlertController(title: "Added to Cart", message:
            "\(quantity) \(name)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func getData() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
//        request.returnsObjectsAsFaults = false
//
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//                print()
//                print(data)
//                print(data.value(forKey: "name"))
//                print(data.value(forKey: "price"))
//                print(data.value(forKey: "quantity"))
//                print()
//            }
//        } catch {
//            print("Failed to retrieved object...")
//        }
//    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        if quantity == 0 {
            minusButton.backgroundColor = UIColor.red
        }
        quantity += 1
        itemQuantity.text = String(format:"%.f",quantity)
        let item = self.selectedItem
        let adjustedPrice = item["price"] as! Double * quantity
        itemPrice.text = "$\(String(format:"%.2f", adjustedPrice))"
    }
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        if quantity == 1 {
            
        }
        else {
            quantity -= 1
            itemQuantity.text = String(format:"%.f",quantity)
            let item = self.selectedItem
            let adjustedPrice = item["price"] as! Double * quantity
            itemPrice.text = "$\(String(format:"%.2f", adjustedPrice))"
        }
    }
    
    
    @IBAction func cartButtonPressed(_ sender: UIButton) {
        addOrderToCart()
        
        print("Appending item to cart.")
//        print("Cart Names:",defaults.array(forKey: "cartNames"))
//        print("Cart Quantities:",defaults.array(forKey: "cartQuantities"))
    }
    
}
