//
//  Counter+CoreDataProperties.swift
//  Count_It
//
//  Created by Mohammad Yunus on 09/07/19.
//  Copyright © 2019 SimpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var incBy: Double
    @NSManaged public var createdAt: Date
    @NSManaged public var id: String
    @NSManaged public var photos: [Data]?
    @NSManaged public var title: String
    @NSManaged public var valueAt: [[Date: Double]]
    @NSManaged public var decBy: Double

}
