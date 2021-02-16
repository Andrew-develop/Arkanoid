//
//  Platform+CoreDataProperties.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 20.01.2021.
//
//

import Foundation
import CoreData


extension Platform {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Platform> {
        return NSFetchRequest<Platform>(entityName: "Platform")
    }

    @NSManaged public var name: String?
    @NSManaged public var status: Bool
    @NSManaged public var price: Int16

}
