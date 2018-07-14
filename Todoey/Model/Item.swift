//
//  Item.swift
//  Todoey
//
//  Created by viNs on 7/11/18.
//  Copyright © 2018 Vinay Soni. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
