//
//  CurrentGame+CoreDataProperties.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 20.01.2021.
//
//

import Foundation
import CoreData


extension CurrentGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentGame> {
        return NSFetchRequest<CurrentGame>(entityName: "CurrentGame")
    }

    @NSManaged public var score: Int16
    @NSManaged public var lives: Int16
    @NSManaged public var level: Int16

}
