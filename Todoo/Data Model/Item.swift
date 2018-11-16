//
//  Item.swift
//  Todoo
//
//  Created by Asgedom Yohannes on 11/15/18.
//  Copyright © 2018 Asgedom Y. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self,property: "items")
}
