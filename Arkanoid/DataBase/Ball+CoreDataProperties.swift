//
//  Ball+CoreDataProperties.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 20.01.2021.
//
//

import Foundation
import CoreData


extension Ball {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ball> {
        return NSFetchRequest<Ball>(entityName: "Ball")
    }

    @NSManaged public var name: String?
    @NSManaged public var status: Bool
    @NSManaged public var price: Int16

}
