//
//  Variant.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import Foundation

final class Variant : JSON, Hashable {
    required init(withData data: [String : Any]) {
        name = data[Constants.name] as? String ?? ""
        if let identity = data[Constants.id] as? String, let intId = Int(identity) {
            id = intId
        }
        price = data[Constants.price] as? Int ?? 0
        isDefault = data[Constants.isDefault] as? Bool ?? false
        inStock = data[Constants.inStock] as? Bool ?? false
        isVeg = data[Constants.isVeg] as? Bool ?? false
    }
    weak var group : Group!
    var name : String = ""
    var id : Int = 0
    var price : Int = 0
    var isDefault : Bool = false
    var inStock : Bool = false
    var isVeg : Bool = false
    var hashValue : Int {
    return id
    }
}
extension Variant : Equatable {
    static func == (lhs: Variant, rhs: Variant) -> Bool {
        return lhs.id == rhs.id
    }
}
