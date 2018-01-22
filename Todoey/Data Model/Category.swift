//
//  Category.swift
//  Todoey
//
//  Created by Suruchi Singh on 1/21/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
    
    
}
