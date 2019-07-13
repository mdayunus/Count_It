//
//  NewCounterViewController.swift
//  Count_It
//
//  Created by Mohammad Yunus on 03/07/19.
//  Copyright © 2019 SimpleApp. All rights reserved.
//

import UIKit

class NewCounterViewController: UIViewController {
    
    //properties
    
    var container = AppDelegate.container
    
    var imageDataContainer = [Data]()
    
    // Outlets and Actions
    
    @IBOutlet weak var titleField: UITextField!{
        didSet{
            titleField.delegate = self
        }
    }
    
    
    @IBOutlet weak var incTextField: UITextField!{
        didSet{
            incTextField.delegate = self
        }
    }
    
    @IBOutlet weak var decTextField: UITextField!{
        didSet{
            decTextField.delegate = self
        }
    }
    
    @IBOutlet weak var initialValueField: UITextField!{
        didSet{
            initialValueField.delegate = self
        }
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView!{
        didSet{
            imageCollectionView.delegate = self
            imageCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var createCounterButtonOutlet: UIButton!{
        didSet{
            // change the button appearance here
        }
    }
    
    @IBAction func createCounterButton(_ sender: UIButton) {
        guard let container = container else{return}
        if titleField.text!.isBlank || incTextField.text!.isBlank || decTextField.text!.isBlank || initialValueField.text!.isBlank{
            Alerts.emptyField(on: self)
        }else{
            if let incBy = Double(incTextField.text!), let decBy = Double(decTextField.text!), let initialValue = Double(initialValueField.text!) {
                let nc = Counter(context: container.viewContext)
                nc.createdAt = Date()
                nc.id = UUID().uuidString
                nc.title = titleField.text!
                nc.incBy = incBy
                nc.decBy = decBy
                nc.valueAt = [[Date(): initialValue]]
                nc.photos = imageDataContainer
            }else{
                Alerts.notAValidNumber(on: self)
            }
        }
        if container.viewContext.hasChanges{
            do{
                try container.viewContext.save()
            }catch{
                fatalError()
            }
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    // functions
    
    @objc func getImageFromLibrary(){
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
}
extension NewCounterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case titleField:
            titleField.resignFirstResponder()
            incTextField.becomeFirstResponder()
            return true
        case incTextField:
            incTextField.resignFirstResponder()
            decTextField.becomeFirstResponder()
            return true
        case decTextField:
            decTextField.resignFirstResponder()
            initialValueField.becomeFirstResponder()
            return true
        case initialValueField:
            initialValueField.resignFirstResponder()
            return true
        default:
            return false
        }
    }
}

extension NewCounterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataContainer.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: CellIDs.addNewPhotoCell, for: indexPath)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getImageFromLibrary)))
            return cell
        default:
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: CellIDs.showPhotoCell, for: indexPath) as? PhotoCollectionViewCell
            cell?.myImageView.image = UIImage(data: imageDataContainer[indexPath.row - 1])
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        return size
    }
    
    
}

extension NewCounterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            if let imageData = image.jpegData(compressionQuality: 40){
                imageDataContainer.append(imageData)
            }
        }
        imageCollectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension String{
    var isBlank: Bool{
        return allSatisfy({$0.isWhitespace})
    }
}
