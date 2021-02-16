//
//  ViewController.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 17.12.2020.
//

import UIKit
import Bond
import SwiftGifOrigin

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var playOutlet: UIButton!
    @IBOutlet weak var statOutlet: UIButton!
    @IBOutlet weak var descOutlet: UIButton!
    @IBOutlet weak var setOutlet: UIButton!
    @IBOutlet weak var coinsLabel: UILabel!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [playOutlet, statOutlet, descOutlet, setOutlet].forEach { (sender) in
            sender?.layer.cornerRadius = 20
            sender?.layer.borderWidth = 2
            sender?.layer.borderColor = UIColor.white.cgColor
        }
        backgroundImage.loadGif(asset: "stars")
        
        viewModel.startSetup()
        viewModel.coins.bind(to: coinsLabel)
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "game") as! GameViewController
        navigationController?.pushViewController(vc, animated: true)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func statisticsButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "statistic") as! StatisticViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func aboutUsButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "aboutUs") as! AboutUsViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func marketButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "market") as! MarketViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}

