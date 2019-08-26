//
//  JSON.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import Foundation

protocol JSON {
    init(withData data : [String : Any])
    static func instantiate(withDataArray array : [[String : Any]]) -> [Self]
}

extension JSON where Self : Any {
    static func instantiate(withDataArray array : [[String : Any]]) -> [Self] {
        var objArray : [Self] = []
        for obj in array {
            objArray.append(self.init(withData: obj))
        }
        return objArray
    }
}
