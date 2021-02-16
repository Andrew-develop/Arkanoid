//
//  AppDelegate.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 17.12.2020.
//

import UIKit
import CoreData
import AVFoundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    var audioPlayer = AVAudioPlayer()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if CoreDataHelper().userRequest().sound {
            let path = Bundle.main.path(forResource: "sound", ofType: "mp3")!
            let url = URL(fileURLWithPath: path)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
            } catch {
                print("error")
            }
        }
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let user = try! context.fetch(fetchRequest)
        
        if user.count == 0 {
            let newUser = User(context: context)
            newUser.coins = 0
            newUser.control = "slides"
            newUser.sound = true
            newUser.speed = -5
            
            for i in 0..<4 {
                let newBall = Ball(context: context)
                newBall.name = "ball\(i)"
                newBall.status = false
                newBall.price = Int16(i * 100)
                if i == 0 {
                    newBall.status = true
                }
            }
            
            for i in 0..<4 {
                let newPlatform = Platform(context: context)
                newPlatform.name = "platform\(i)"
                newPlatform.status = false
                newPlatform.price = Int16(i * 100)
                if i == 0 {
                    newPlatform.status = true
                }
            }
            saveContext()
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        let content = UNMutableNotificationContent()
        content.title = "Пора играть!"
        content.body = "Новый день - новые впечатления!"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
        }
        
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Arkanoid")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

