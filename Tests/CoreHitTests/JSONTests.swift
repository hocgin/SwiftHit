//
//  File.swift
//  
//
//  Created by hocgin on 2022/8/7.
//

import XCTest
@testable import CoreHit
import SwiftyStoreKit

final class JSONTests: XCTestCase {
    
    
    func testJSONString() throws {
        let entity = DataExample()
        print("\(entity.toJSONString())")
    }
    
    func testJSONObject() throws {
        let str = """
            {"id":"1","name":"hocgin"}
            """
        let entity = DataExample.parseObject(str)
        print("\(entity.toJSONString())")
        
    }
}

struct DataExample: Codable {
    var id: String = "12"
    var name: String = "hocgin"
}
