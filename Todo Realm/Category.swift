//
//  Category.swift
//  Todo Realm
//
//  Created by Sai Abhilash Gudavalli on 02/07/22.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
