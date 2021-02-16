//
//  StatisticViewController.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 12.01.2021.
//

import UIKit
import CoreData

class StatisticViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [GameResults]()
    var sortMode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = CoreDataHelper().gameResults()
    }
    
    @IBAction func sortStatistics(_ sender: UIButton) {
        if sortMode == 0 {
            data.sort {
                $0.level > $1.level
            }
            sortMode = 1
        }
        else if sortMode == 1 {
            data.sort {
                $0.score > $1.score
            }
            sortMode = 2
        }
        else {
            data.sort {
                $0.date > $1.date
            }
            sortMode = 0
        }
        tableView.reloadData()
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension StatisticViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StatisticTableViewCell
        cell.number.text = String(data[indexPath.row].level)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.date.text = formatter.string(from: data[indexPath.row].date)
        cell.score.text = "Score: \(data[indexPath.row].score)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
