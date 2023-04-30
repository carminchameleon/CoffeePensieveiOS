//
//  AuthData+CoreDataProperties.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/27.
//
//

import Foundation
import CoreData


extension AuthData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthData> {
        return NSFetchRequest<AuthData>(entityName: "AuthData")
    }

    @NSManaged public var isLoggedIn: Bool

}

extension AuthData : Identifiable {

}
