//
//  Sample+CoreDataProperties.swift
//  sampleNote
//
//  Created by Mohan K on 15/03/23.
//
//

import Foundation
import CoreData


extension Sample {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sample> {
        return NSFetchRequest<Sample>(entityName: "Sample")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var title: String?

}

extension Sample : Identifiable {

}
