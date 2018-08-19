//
//  Item.swift
//  Todoey
//
//  Created by Gabriel Raymondou on 19/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
    
}
