//
//  MarketViewController.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 16.01.2021.
//

import UIKit
import CoreData

class MarketViewController: UIViewController {
    
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var platformCollectionView: UICollectionView!
    @IBOutlet weak var ballCollectionView: UICollectionView!

    var dataPlatform : [Platform]?
    var dataBall : [Ball]?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = appDelegate.persistentContainer.viewContext
        
        let ballFetchRequest: NSFetchRequest<Ball> = Ball.fetchRequest()
        dataBall = try! context.fetch(ballFetchRequest)
        
        let platformFetchRequest: NSFetchRequest<Platform> = Platform.fetchRequest()
        dataPlatform = try! context.fetch(platformFetchRequest)
        
        dataPlatform!.sort {
            $0.price < $1.price
        }
        
        dataBall!.sort {
            $0.price < $1.price
        }
        
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let user = try! context.fetch(userFetchRequest)
        
        coinsLabel.text = "Coins: \(user[0].coins)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === platformCollectionView {
            return dataPlatform!.count
        }
        else if collectionView === ballCollectionView {
            return dataBall!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === platformCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPlatform", for: indexPath)
            let myColor = UIColor.white
            (cell.viewWithTag(1) as! UIImageView).layer.borderWidth = 1
            (cell.viewWithTag(1) as! UIImageView).layer.borderColor = myColor.cgColor
            (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 4
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: dataPlatform![indexPath.row].name!)
            if dataPlatform![indexPath.row].price > 0 {
                (cell.viewWithTag(2) as! UILabel).text = "Price: \(dataPlatform![indexPath.row].price)"
                (cell.viewWithTag(2) as! UILabel).textColor = .white
            }
            else if dataPlatform![indexPath.row].status {
                (cell.viewWithTag(2) as! UILabel).text = "Selected"
                (cell.viewWithTag(2) as! UILabel).textColor = .green
            }
            else {
                (cell.viewWithTag(2) as! UILabel).text = "Available"
                (cell.viewWithTag(2) as! UILabel).textColor = .blue
            }
            return cell
        }
        else if collectionView === ballCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBall", for: indexPath)
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: dataBall![indexPath.row].name!)
            if dataBall![indexPath.row].price > 0 {
                (cell.viewWithTag(2) as! UILabel).text = "Price: \(dataBall![indexPath.row].price)"
                (cell.viewWithTag(2) as! UILabel).textColor = .white
            }
            else if dataBall![indexPath.row].status {
                (cell.viewWithTag(2) as! UILabel).text = "Selected"
                (cell.viewWithTag(2) as! UILabel).textColor = .green
            }
            else {
                (cell.viewWithTag(2) as! UILabel).text = "Available"
                (cell.viewWithTag(2) as! UILabel).textColor = .blue
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: collectionView.frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let context = appDelegate.persistentContainer.viewContext
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let user = try! context.fetch(userFetchRequest)
        
        if collectionView === platformCollectionView {
            if dataPlatform![indexPath.row].price > 0 && user[0].coins >= dataPlatform![indexPath.row].price {
                let alert = UIAlertController(title: "Buy", message: "Do you really want to buy this staff?", preferredStyle: .alert)
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                let action = UIAlertAction(title: "Yes", style: .default) { _ in
                    user[0].coins -= self.dataPlatform![indexPath.row].price
                    self.coinsLabel.text = "Coins: \(user[0].coins)"
                    self.dataPlatform![indexPath.row].price = 0
                    self.appDelegate.saveContext()
                    collectionView.reloadData()
                }
                alert.addAction(noAction)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if dataPlatform![indexPath.row].price > 0 && user[0].coins < dataPlatform![indexPath.row].price {
                let alert = UIAlertController(title: "Buy", message: "You don't have enough coins", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                dataPlatform!.forEach { (platform) in
                    platform.status = false
                }
                dataPlatform![indexPath.row].status = true
                appDelegate.saveContext()
                collectionView.reloadData()
            }
        }
        else if collectionView === ballCollectionView {
            if dataBall![indexPath.row].price > 0 && user[0].coins >= dataBall![indexPath.row].price {
                let alert = UIAlertController(title: "Buy", message: "Do you really want to buy this staff?", preferredStyle: .alert)
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                let action = UIAlertAction(title: "Yes", style: .default) { _ in
                    user[0].coins -= self.dataBall![indexPath.row].price
                    self.coinsLabel.text = "Coins: \(user[0].coins)"
                    self.dataBall![indexPath.row].price = 0
                    self.appDelegate.saveContext()
                    collectionView.reloadData()
                }
                alert.addAction(noAction)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if dataBall![indexPath.row].price > 0 && user[0].coins < dataBall![indexPath.row].price {
                let alert = UIAlertController(title: "Buy", message: "You don't have enough coins", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                dataBall!.forEach { (platform) in
                    platform.status = false
                }
                dataBall![indexPath.row].status = true
                appDelegate.saveContext()
                collectionView.reloadData()
            }
        }
    }
}
