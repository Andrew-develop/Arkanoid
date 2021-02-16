//
//  User+CoreDataProperties.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 20.01.2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var sound: Bool
    @NSManaged public var speed: Double
    @NSManaged public var control: String?
    @NSManaged public var coins: Int16

}
