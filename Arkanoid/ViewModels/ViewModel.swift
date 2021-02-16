//
//  ViewModel.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 22.01.2021.
//

import Bond

class ViewModel {
    
    var coins = Observable<String>("")
    
    func startSetup() {
        self.coins = Observable<String>("Coins: \(CoreDataHelper().userRequest().coins)")
    }
}

