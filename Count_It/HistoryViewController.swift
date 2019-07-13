//
//  HistoryViewController.swift
//  Count_It
//
//  Created by Mohammad Yunus on 04/07/19.
//  Copyright © 2019 SimpleApp. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // properties
    
    var selectedCounter: Counter!
    
    // outlets and actions
    
    @IBOutlet weak var historyTableView: UITableView!{
        didSet{
            historyTableView.dataSource = self
            historyTableView.delegate = self
        }
    }
    
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCounter.valueAt.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text  = "\(selectedCounter.valueAt[indexPath.row].values.first!)"
        cell.detailTextLabel?.text = selectedCounter.valueAt[indexPath.row].keys.first!.description
        return cell
    }
    
}
