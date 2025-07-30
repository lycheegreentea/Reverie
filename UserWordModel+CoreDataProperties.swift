//
//  UserWordModel+CoreDataProperties.swift
//  Reverie
//
//  Created by Lauren Chen on 7/12/25.
//
//

import Foundation
import CoreData


extension UserWordModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserWordModel> {
        return NSFetchRequest<UserWordModel>(entityName: "UserWordModel")
    }

    @NSManaged public var word: String?
    @NSManaged public var definition: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?

}

extension UserWordModel : Identifiable {

}
