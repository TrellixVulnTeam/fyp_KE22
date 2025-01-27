//
//  Touch+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Student on 18/10/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import Foundation
import CoreData


extension Touch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Touch> {
        return NSFetchRequest<Touch>(entityName: "Touch");
    }

    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var t: Double
    @NSManaged public var f: Double
    @NSManaged public var index: Int32
    @NSManaged public var stroke: Stroke?

}
