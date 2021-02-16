//
//  SettingsViewController.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 18.12.2020.
//

import UIKit
import Bond
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var clearOutlet: UIButton!
    @IBOutlet weak var speedOutlet: UISlider!
    @IBOutlet weak var controlOutlet: UISegmentedControl!
    @IBOutlet weak var soundOutlet: UISegmentedControl!
    
    let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        speedOutlet.minimumValue = -10
        speedOutlet.maximumValue = -4
        speedOutlet.value = Float(CoreDataHelper().userRequest().speed)
        clearOutlet.layer.cornerRadius = 10
        clearOutlet.layer.borderWidth = 1
        clearOutlet.layer.borderColor = UIColor.white.cgColor
        
        if CoreDataHelper().userRequest().sound {
            soundOutlet.selectedSegmentIndex = 0
        }
        else {
            soundOutlet.selectedSegmentIndex = 1
        }
        if CoreDataHelper().userRequest().control == "slopes" {
            controlOutlet.selectedSegmentIndex = 0
        }
        else {
            controlOutlet.selectedSegmentIndex = 1
        }
        
        viewModel.startSetup()
        viewModel.speed.bind(to: speedOutlet)
    }

    @IBAction func speedSlider(_ sender: UISlider) {
        viewModel.changeCoreDataUser(name: "speed", value: Double(sender.value))
    }
    
    @IBAction func controlSegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewModel.changeCoreDataUser(name: "control", value: "slopes")
        }
        else {
            viewModel.changeCoreDataUser(name: "control", value: "slides")
        }
    }
    
    @IBAction func soundSegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewModel.changeCoreDataUser(name: "sound", value: true)
        }
        else {
            viewModel.changeCoreDataUser(name: "sound", value: false)
        }
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Attention", message: "Вы действительно хотите очистить статистику?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Да", style: .default) { _ in
            self.viewModel.deleteGameResults()
        }
        let noAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
