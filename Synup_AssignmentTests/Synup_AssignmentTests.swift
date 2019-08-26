//
//  Synup_AssignmentTests.swift
//  Synup_AssignmentTests
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import XCTest
@testable import Synup_Assignment

class Synup_AssignmentTests: XCTestCase {
    
    var groupsService : GroupsService?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        groupsService = GroupsService()
        testAPICall()
        testGroup()
        testVariation()
    }
    
    override func tearDown() {
        groupsService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAPICall(){
        let promise = expectation(description: "Status code: 200")
        groupsService!.getGroups(completion: {(groups, exclusions, error) in
            if error != nil {
                XCTFail("Error: \(error!.localizedDescription)")
                return
            }
            if groups == nil {
                XCTFail("Error: No groups were found")
                return
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 60)
    }
    
    func testGroup() {
        let demoData = ["group_id":"1","name":"Crust","variations":[["name":"Thin","price":0,"default":1,"id":"1","inStock":1],["name":"Thick","price":0,"default":0,"id":"2","inStock":1,"isVeg":1],["name":"Cheese burst","price":100,"default":0,"id":"3","inStock":1,"isVeg":1]]] as [String : Any]
        let group = Group.init(withData: demoData)
        if let grpID =  demoData[Constants.groupID]  as? String, let intGrp = Int(grpID) {
            XCTAssertEqual(group.id, intGrp)
        }
        XCTAssertEqual(group.name, demoData[Constants.name] as? String ?? "")
        
        if let variantsArray = demoData[Constants.variations] as? [[String : Any]] {
            XCTAssertEqual(Variant.instantiate(withDataArray: variantsArray), group.variants)
        }
    }
    
    func testVariation() {
        let demoData = ["name":"Thin","price":0,"default":1,"id":"1","inStock":1] as [String : Any]
        let variant = Variant.init(withData: demoData)
        XCTAssertEqual(demoData[Constants.name] as? String ?? "", variant.name)
        
        if let identity = demoData[Constants.id] as? String, let intId = Int(identity) {
            XCTAssertEqual(intId, variant.id)
        }
        XCTAssertEqual( demoData[Constants.price] as? Int ?? 0, variant.price)
        XCTAssertEqual( demoData[Constants.isDefault] as? Bool ?? false, variant.isDefault)
        XCTAssertEqual( demoData[Constants.inStock] as? Bool ?? false, variant.inStock)
        XCTAssertEqual( demoData[Constants.isVeg] as? Bool ?? false, variant.isVeg)
        XCTAssertFalse(variant.id == 0)
    }
}
