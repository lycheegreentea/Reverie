//
//  UserQuoteModel+CoreDataProperties.swift
//  Reverie
//
//  Created by Lauren Chen on 7/12/25.
//
//

import Foundation
import CoreData


extension UserQuoteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserQuoteModel> {
        return NSFetchRequest<UserQuoteModel>(entityName: "UserQuoteModel")
    }

    @NSManaged public var quote: String?
    @NSManaged public var author: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?

}

extension UserQuoteModel : Identifiable {

}
