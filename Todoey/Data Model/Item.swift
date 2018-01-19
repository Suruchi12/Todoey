//
//  Item.swift
//  Todoey
//
//  Created by Suruchi Singh on 1/16/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
class Item: Codable {   //Encodable, Decodable
    var title : String = ""
    var done : Bool = false
}
