//
//  Order+CoreDataProperties.swift
//  
//
//  Created by Christian Luarca on 4/19/19.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Double

}
