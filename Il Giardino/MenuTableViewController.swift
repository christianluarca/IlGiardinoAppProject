//
//  MenuTableViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/11/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData

class MenuTableViewController: UITableViewController {
    
    var container: NSPersistentContainer?
    var dataLoaded = false
    
    @IBOutlet var menuTableView: UITableView!
    
    var itemSelected = false
    
    var menu: [menuCategory] = []
    
    class menuItem {
        var name: String = ""
        var desc: String = ""
        var imgURL: String = ""
        var img: UIImage = UIImage()
    }
    
    class menuCategory {
        var name: String = ""
        var items: [menuItem] = []
        var price: Double = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Menu"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Book", size: 25)!]
        
        createLoadingView()
        
        tableView.rowHeight = 275
        
        if !dataLoaded {
            loadData()
        }
        
////      You can create a item in the database simply by referencing what it should be, even if it           doesn't exit yet. Furthermore, you may set values for its keys; this creates the object, its        keys, and the values of those keys simultaneously
//
//        let newUserRef = ref.child("User").child("user0")
//        newUserRef.child("name").setValue("Nikko")
//        newUserRef.child("age").setValue(25)
        
        //Setting back button font for next page to Avenir Heavy 25pt
        let backButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 25)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "icon-cart"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(MenuTableViewController.cartTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        
        //        let button2 = UIButton(type: .custom)
        //        button2.setImage(UIImage (named: "icon-home"), for: .normal)
        //        button2.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        //        button.addTarget(self, action: #selector(HomeViewController.homeTapped), for: .touchUpInside)
        //        let barButtonItem2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.rightBarButtonItems = [barButtonItem]
        
    }

    @objc func cartTapped(sender:UIButton) {
        performSegue(withIdentifier: "showCart", sender: nil)
    }
    
    func loadData() {
        let menuRef = Database.database().reference().child("Menu")
        
        menuRef.observeSingleEvent(of: .value) { (snapshot) in
    
            //Cast snapshot to NSDictionary type
            let snapshotMenu = snapshot.value as! NSDictionary
            //For each category in the menu...
            for category in snapshotMenu {
                //...create a new menuCategory instance.
                let currentCategory = menuCategory()
                currentCategory.name = category.key as! String
                let items = category.value as! NSDictionary
                for item in items {
                    if item.key as! String == "price" {
                        currentCategory.price = item.value as! Double
                    }
                    else {
                        let currentItem = menuItem()
                        currentItem.name = item.key as! String
                        let properties = item.value as! NSDictionary
                        for property in properties {
                            if property.key as! String == "desc" {
                                currentItem.desc = property.value as! String
                            }
                                //                          FOR SOME REASON WHEN I USE AN IF OR ELSE IF STATEMENT, IT DOESN'T PASS THE CONDITION
                                //                          if property.key as! String == "imgUrl" {
                            else {
                                currentItem.imgURL = property.value as! String
                                //ONLY SECURED URLS WORK
                                //                                print("URL: \(currentItem.imgURL)")
                                let imageUrl = URL(string: currentItem.imgURL)!
                                let imageData = try! Data(contentsOf: imageUrl)
                                let image = UIImage(data: imageData)!
                                currentItem.img = image
                            }
                        }
                        currentCategory.items.append(currentItem)
                    }
                }
                self.menu.append(currentCategory)
                self.menuTableView.reloadData()
            }
        }
        dataLoaded = true
    }
    
    func createLoadingView() {
        let child = LoadingViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    // MARK: - Table view data source

    //How many rows?
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        for _ in self.menu {
            sections += 1
        }
        return sections
    }

    //How many sections per row?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        for _ in self.menu[section].items {
            rows += 1
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath as IndexPath) as! MenuTableViewCell

        let itemsInCategory = self.menu[indexPath.section].items
        let item = itemsInCategory[indexPath.row]
        let name = item.name
        let image = item.img

        // Use reference variable to set values of specified element of prototype cell
        cell.nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        cell.nameLabel.text = name
        cell.imageLabel.image = image
        
        return cell
    }

    // What are the names of the sections?
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = self.menu[section]
        return ("\(category.name) - $\(category.price)")
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(red: 47.0/255.0, green: 61.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Avenir Book", size: 25)!
        header.textLabel?.textColor = UIColor.white
    }
    
    // What happens when you tap on a row?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let category = self.menu[indexPath.section]
        let item = category.items[indexPath.row]
        let selectedItem: [String: Any] = [
            "name"      : item.name,
            "category"  : category.self.name,
            "desc"      : item.desc,
            "price"     : category.price,
            "img"       : item.img
        ]
        
        itemSelected = true
        
        // Remove highlight after tap.
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Segue and send object
        performSegue(withIdentifier: "showSelectedItemView", sender: selectedItem)
    }

    // Prepare data to be received by intended view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Target view controller
        if itemSelected {
            let selectedItemView = segue.destination as! SelectedItemViewController
            // Set a value of a variable within that view controller as
            selectedItemView.selectedItem = sender as! [String: Any]
            itemSelected = false
        }
        if let nextVC = segue.destination as? SelectedItemViewController {
            nextVC.container = container
        }
    }
}
