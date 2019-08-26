//
//  GroupsService.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import Foundation

class GroupsService {
    private lazy var queryMgr = JSONQuery()
    private let url = "https://api.myjson.com/bins/19u0sf"
    public typealias completionBlock = (_ data : [Group]?,_ exclusions : [[Exclusion]]?,_ error : Error?) -> Void
    public func getGroups(completion : @escaping completionBlock) {
        queryMgr.request(withUrl: url, method: .get, parameters: nil, headers: [:], successBlock: { (data) in
            if let dict = data as? [String : Any] {
                if let variantDict = dict[Constants.variantsArray] as? [String : Any] {
                    if let groups = variantDict[Constants.variantsGroups] as? [[String : Any]] {
                        let groups = Group.instantiate(withDataArray: groups)
                        if let exculsions = variantDict["exclude_list"] as? [[[String : Any]]] {
                            let arrays = exculsions.compactMap({Exclusion.instantiate(withDataArray: $0)})
                            completion(groups,arrays, nil)
                        } else {
                            completion(groups,nil, nil)
                        }
                        return
                    }
                }
            }
            completion(nil,nil,nil)
        }) { (error, data) in
            completion(nil,nil,error)
        }
    }
}
