//
//  Item.swift
//  Todoey
//
//  Created by Gabriel Raymondou on 19/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    // MARK: - Properties
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    // MARK: - Relationships
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
