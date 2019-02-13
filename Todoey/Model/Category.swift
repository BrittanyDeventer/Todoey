//
//  Category.swift
//  Todoey
//
//  Created by Brittany Deventer on 2/12/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    // Relationships - link one to many
    let items = List<Item>() //initialize an empty list of Item objects
}
