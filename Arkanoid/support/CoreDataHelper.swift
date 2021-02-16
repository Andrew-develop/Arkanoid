//
//  CoreDataHelper.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 22.01.2021.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func userRequest() -> User {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let user = try! context.fetch(fetchRequest)
        return user[0]
    }
    
    func gameResults() -> [GameResults] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GameResults> = GameResults.fetchRequest()
        let data = try! context.fetch(fetchRequest)
        return data
    }
    
    func saveData() {
        appDelegate.saveContext()
    }
    
    func deleteFromCoreData<T : NSManagedObject>(mass : [T]) {
        let context = appDelegate.persistentContainer.viewContext
        
        mass.forEach { (element) in
            context.delete(element)
        }
        appDelegate.saveContext()
    }

}
