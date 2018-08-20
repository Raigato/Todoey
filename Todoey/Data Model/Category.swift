//
//  Category.swift
//  Todoey
//
//  Created by Gabriel Raymondou on 19/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    // MARK: - Properties
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    // MARK: - Relationships
    let items = List<Item>()
    
}
