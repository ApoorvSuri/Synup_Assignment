//
//  Exclusion.swift
//  Synup_Assignment
//
//  Created by cronycle on 26/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

final class Exclusion : JSON {
    var groupID : Int = 0
    var variationID : Int = 0
    var variant : Variant?
    required init(withData data: [String : Any]) {
        if let grpID = data["group_id"] as? String, let intGrpID = Int(grpID) {
            groupID = intGrpID
        }
        if let variatnID = data["variation_id"] as? String, let intVariationID = Int(variatnID) {
            variationID = intVariationID
        }
    }
}
