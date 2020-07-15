//
//  MenuCollectionViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 5/22/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MenuCollectionViewController: UICollectionViewController {

    var menu: [menuCategory] = [menuCategory(),menuCategory(),menuCategory(),menuCategory()]
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        loadMenu()
        
        // Do any additional setup after loading the view.
    }

    func loadMenu() {
        
        let menuRef = Database.database().reference().child("Menu")
        
        let entree = DispatchQueue(label: "entree")
        let pasta = DispatchQueue(label: "pasta")
        let sandwich = DispatchQueue(label: "sandwich")
        let salad = DispatchQueue(label: "salad")
        
        func findIndex(_ categoryName: String) -> Int {
            for i in 0...self.menu.count-1 {
                if self.menu[i].name == categoryName {
                    print("found \(categoryName): \(i)")
                    return i
                }
            }
            return 0
        }
        
        entree.async {
            menuRef.child("Entrées").observeSingleEvent(of: .value) { (snapshot) in
                
                let currentCategory = menuCategory()
                currentCategory.name = "Entrées"
                self.menu[1] = currentCategory
                
                let categoryIndex = 1
                
                let items = snapshot.value as! NSDictionary
                for item in items {
                    let thisCategory = self.menu[categoryIndex]
                    if item.key as! String == "price" {
                        thisCategory.price = item.value as! Double
                        self.collectionView.reloadData()
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
                        thisCategory.items.append(currentItem)
                        print("reloading entrees")
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        pasta.async {
            menuRef.child("Pasta Specials").observeSingleEvent(of: .value) { (snapshot) in
                
                let currentCategory = menuCategory()
                currentCategory.name = "Pasta Specials"
                self.menu[0] = currentCategory
                
                let categoryIndex = 0
                
                let items = snapshot.value as! NSDictionary
                for item in items {
                    let thisCategory = self.menu[categoryIndex]
                    if item.key as! String == "price" {
                        thisCategory.price = item.value as! Double
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
                        thisCategory.items.append(currentItem)
                        print("reloading pastas")
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        sandwich.async {
            menuRef.child("Sandwiches").observeSingleEvent(of: .value) { (snapshot) in
                
                let currentCategory = menuCategory()
                currentCategory.name = "Sandwiches"
                self.menu[2] = currentCategory
                
                let categoryIndex = 2
                
                let items = snapshot.value as! NSDictionary
                for item in items {
                    let thisCategory = self.menu[categoryIndex]
                    if item.key as! String == "price" {
                        thisCategory.price = item.value as! Double
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
                        thisCategory.items.append(currentItem)
                        print("reloading sandwiches")
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        salad.async {
            menuRef.child("Salads").observeSingleEvent(of: .value) { (snapshot) in
                
                let currentCategory = menuCategory()
                currentCategory.name = "Salads"
                self.menu[3] = currentCategory
                
                let categoryIndex = 3
                
                let items = snapshot.value as! NSDictionary
                for item in items {
                    let thisCategory = self.menu[categoryIndex]
                    if item.key as! String == "price" {
                        thisCategory.price = item.value as! Double
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
                        thisCategory.items.append(currentItem)
                        print("reloading salads")
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func loadData() {
        let menuRef = Database.database().reference().child("Menu")
        
        menuRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //Cast snapshot to NSDictionary type
            let snapshotMenu = snapshot.value as! NSDictionary
            
            var categoryIndex = 0
            
            //For each category in the menu...
            for category in snapshotMenu {
                //...create a new menuCategory instance.
                let currentCategory = menuCategory()
                currentCategory.name = category.key as! String
                self.menu.append(currentCategory)
                let items = category.value as! NSDictionary
                for item in items {
                    let thisCategory = self.menu[categoryIndex]
                    if item.key as! String == "price" {
                        thisCategory.price = item.value as! Double
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
                        thisCategory.items.append(currentItem)
                        print("reloading here")
                        self.collectionView.reloadData()
                    }
                }
                categoryIndex += 1
//                self.menu.append(currentCategory)
                print("reloading herefdsafds")
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var sections = 0
        for _ in self.menu {
            sections += 1
        }
        return sections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sections = 0
        for _ in self.menu[section].items {
            sections += 1
        }
        return sections
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell

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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
