//
//  SettingsViewModel.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 22.01.2021.
//

import Bond

class SettingsViewModel {
    
    var speed = Observable<Float>(0)
    var control = Observable<Int?>(nil)
    var sound = Observable<Int?>(nil)
    
    func startSetup() {
        speed = Observable<Float>(Float(CoreDataHelper().userRequest().speed))
    }
    
    func changeCoreDataUser<T>(name : String, value: T) {
        if name == "control" {
            CoreDataHelper().userRequest().control = value as? String
        }
        else if name == "speed" {
            CoreDataHelper().userRequest().speed = value as! Double
        }
        else if name == "sound" {
            CoreDataHelper().userRequest().sound = value as! Bool
        }
        CoreDataHelper().saveData()
    }
    
    func deleteGameResults() {
        let results = CoreDataHelper().gameResults()
        CoreDataHelper().deleteFromCoreData(mass: results)
    }
}
