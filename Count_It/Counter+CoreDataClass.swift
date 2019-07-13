//
//  Counter+CoreDataClass.swift
//  Count_It
//
//  Created by Mohammad Yunus on 09/07/19.
//  Copyright © 2019 SimpleApp. All rights reserved.
//
//

import Foundation
import CoreData


public class Counter: NSManagedObject {
    
    func changeCounterValue(by givenValue: Double){
        if let lastValue = valueAt.last?.values.first{
            let newValue = lastValue + givenValue
            valueAt.append([Date() : newValue])
        }else{
            if let firstValue = valueAt.first?.values.first{
                let newValue = firstValue + givenValue
                valueAt.append([Date() : newValue])
            }
        }
    }
    
}
