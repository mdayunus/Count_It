//
//  CounterDetailViewController.swift
//  Count_It
//
//  Created by Mohammad Yunus on 03/07/19.
//  Copyright © 2019 SimpleApp. All rights reserved.
//

import UIKit

class CounterDetailViewController: UIViewController {
    
    // properties
    
    var selectedCounter: Counter!
    
    var container = AppDelegate.container
    
    // outelets and actions
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = selectedCounter.title
            NotificationCenter.default.addObserver(self, selector: #selector(refreshTitle), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        }
    }
    
    @IBOutlet weak var currentValueLabel: UILabel!{
        didSet{
            currentValueLabel.layer.cornerRadius = 25
            currentValueLabel.layer.borderWidth = 0.5
            currentValueLabel.layer.borderColor = UIColor.darkGray.cgColor
            currentValueLabel.layer.masksToBounds = true
            if let last = selectedCounter.valueAt.last?.values.first{
                currentValueLabel.text = "\(last)"
            }else if let first = selectedCounter.valueAt.first?.values.first{
                currentValueLabel.text = "\(first)"
            }
            currentValueLabel.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipeToGo(swipeDirection:))))
        }
    }
    
    @IBOutlet weak var decrementValue: UIButton!{
        didSet{
            decrementValue.layer.cornerRadius = 25
            decrementValue.layer.borderWidth = 0.5
            decrementValue.layer.borderColor = UIColor.darkGray.cgColor // UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1).cgColor //UIColor.red.cgColor
            decrementValue.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var incrementValue: UIButton!{
        didSet{
            incrementValue.layer.cornerRadius = 25
            incrementValue.layer.borderWidth = 0.5
            incrementValue.layer.borderColor = UIColor.darkGray.cgColor // UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1).cgColor //UIColor.green.cgColor
            incrementValue.layer.masksToBounds = true
        }
    }
    
    @IBAction func decrementValueButton(_ sender: UIButton) {
        guard let c = selectedCounter else{return}
        selectedCounter.changeCounterValue(by: -c.decBy)
        guard let last = selectedCounter.valueAt.last?.values.first else{return}
        currentValueLabel.text = "\(last)"
    }
    
    @IBAction func incrementValueButton(_ sender: UIButton) {
        guard let c = selectedCounter else{return}
        selectedCounter.changeCounterValue(by: c.incBy)
        guard let last = selectedCounter.valueAt.last?.values.first else{return}
        currentValueLabel.text = "\(last)"
    }
    
    @IBAction func closeTheVC(_ sender: UIBarButtonItem) {
        guard let container = container else{return}
        if container.viewContext.hasChanges{
            do{
                try container.viewContext.save()
            }catch{
                fatalError()
            }
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editTheCounter(_ sender: UIBarButtonItem) {
        print("edit")
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.editVC) as? EditViewController{
            dvc.selectedCounter = selectedCounter
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
    @IBOutlet weak var photoCollectionView: UICollectionView!{
        didSet{
            photoCollectionView.dataSource = self
            photoCollectionView.delegate = self
        }
    }
    
    // helper methods
    
    @objc func swipeToGo(swipeDirection: UISwipeGestureRecognizer){
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.historyVC) as? HistoryViewController{
            dvc.selectedCounter = selectedCounter
            navigationController?.show(dvc, sender: self)
        }
    }
    
    @objc func refreshTitle(){
        titleLabel.text = selectedCounter.title
    }
    
    
}
extension CounterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCounter.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: CellIDs.showImageCell, for: indexPath) as! ImageCollectionViewCell
            if let photoData = selectedCounter.photos?[indexPath.row]{
                cell.myImageView.image = UIImage(data: photoData)
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.height)
        return size
    }
    
    
}
