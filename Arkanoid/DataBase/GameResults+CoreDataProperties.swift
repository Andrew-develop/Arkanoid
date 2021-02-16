//
//  GameResults+CoreDataProperties.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 13.01.2021.
//
//

import Foundation
import CoreData


extension GameResults {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameResults> {
        return NSFetchRequest<GameResults>(entityName: "GameResults")
    }

    @NSManaged public var level: Int16
    @NSManaged public var score: Int16
    @NSManaged public var date: Date

}
