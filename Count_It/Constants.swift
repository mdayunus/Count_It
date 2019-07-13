//
//  Constants.swift
//  Count_It
//
//  Created by Mohammad Yunus on 04/07/19.
//  Copyright © 2019 SimpleApp. All rights reserved.
//

import Foundation
import UIKit

struct CellIDs {
    static let counterCell = "counterCell"
    static let historyCell = "historyCell"
    static let addNewPhotoCell = "addNewPhotoCell"
    static let showPhotoCell = "showPhotoCell"
    static let showImageCell = "showImageCell"
    
}

struct VCs {
    static let navConB4CDVC = "navConB4CDVC"
    static let navConB4NPCDVC = "navConB4NPCDVC"
    static let historyVC = "historyVC"
    static let editVC = "editVC"
    
}

struct Alerts {
    static func emptyField(on vc: UIViewController){
        let alertController = UIAlertController(title: "Error", message: "no text field should be left empty", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "try Again", style: .default, handler: .none))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func notAValidNumber(on vc: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: "the number entered is not a valid number", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "retry", style: .default, handler: .none))
        vc.present(alertController, animated: true, completion: nil)
    }
}
