//
//  Category.swift
//  Todoo
//
//  Created by Asgedom Yohannes on 11/15/18.
//  Copyright © 2018 Asgedom Y. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var Color: String = ""
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
