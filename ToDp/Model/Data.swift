//
//  Data.swift
//  ToDp
//
//  Created by ivan cardenas on 03/04/2023.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
