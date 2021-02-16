//
//  CurrentBlock+CoreDataProperties.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 20.01.2021.
//
//

import Foundation
import CoreData


extension CurrentBlock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentBlock> {
        return NSFetchRequest<CurrentBlock>(entityName: "CurrentBlock")
    }

    @NSManaged public var koorX: Int16
    @NSManaged public var koorY: Int16
    @NSManaged public var tag: Int16

}
