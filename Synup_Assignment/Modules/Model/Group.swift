//
//  Group.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import Foundation

final class Group : JSON {
    var name : String = ""
    var id : Int = 0
    var variants : [Variant] = []
    
    required init(withData data: [String : Any]) {
        name = data[Constants.name] as? String ?? ""
        if let grpID =  data[Constants.groupID]  as? String, let intGrp = Int(grpID) {
            id = intGrp
        }
        if let variantsArray = data[Constants.variations] as? [[String : Any]] {
            variants = Variant.instantiate(withDataArray: variantsArray)
        }
        variants.forEach({$0.group = self})
    }
}
