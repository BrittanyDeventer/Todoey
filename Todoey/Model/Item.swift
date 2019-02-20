//
//  Item.swift
//  Todoey
//
//  Created by Brittany Deventer on 2/12/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Inverse Relationship (parent category) - link many to one
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
