//
//  Category.swift
//  Todoey
//
//  Created by bob donovan on 4/20/18.
//  Copyright © 2018 bob donovan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
