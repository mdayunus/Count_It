//
//  ViewController.swift
//  Count_It
//
//  Created by Mohammad Yunus on 03/07/19.
//  Copyright © 2019 SimpleApp. All rights reserved.
//







import UIKit
import CoreData

class ViewController: UIViewController {
    
    //properties
    
    var frc: NSFetchedResultsController<Counter>?
    var container = AppDelegate.container
    
    
    //Outlets and Actions

    @IBOutlet weak var myTableView: UITableView!{
        didSet{
            myTableView.dataSource = self
            myTableView.delegate = self
        }
    }
    
    @objc func getCounters(){
        guard let container = container else{return}
        let request = Counter.createFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try frc?.performFetch()
        }catch{
            fatalError()
        }
        myTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCounters()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getCounters), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: CellIDs.counterCell, for: indexPath)
        if let obj = frc?.object(at: indexPath){
            cell.textLabel?.text = obj.title
            if let lastValue = obj.valueAt.last?.values.first{
                cell.detailTextLabel?.text = "last value: \(lastValue)"
            }else{
                cell.detailTextLabel?.text = "last value: \(obj.valueAt.first!.values.first!)"
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let counter = frc?.object(at: indexPath) else{return}
        guard let photoCount = counter.photos else{return}
        if photoCount.isEmpty{
            if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.navConB4NPCDVC) as? UINavigationController{
                if let npcdvc = dvc.visibleViewController as? NPCounterDetailViewController{
                    npcdvc.selectedCounter = counter
                }
                navigationController?.present(dvc, animated: true, completion: nil)
            }
        }else if !photoCount.isEmpty{
            if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.navConB4CDVC) as? UINavigationController{
                if let cdvc = dvc.visibleViewController as? CounterDetailViewController{
                    cdvc.selectedCounter = frc?.object(at: indexPath)
                }
                navigationController?.present(dvc, animated: true, completion: nil)
            }
        }
    }
    
    
}
