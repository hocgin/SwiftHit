//
//  File.swift
//  
//
//  Created by hocgin on 2022/8/7.
//

import XCTest
@testable import SwiftHit

final class ClassUtilsTests: XCTestCase {
    
    
    func testHasType() throws {
        assert(Utility.hasType(ExampleStruct(), ofType: ExampleStruct.self))
    }
    
    func testToString() throws {
        let entity = ExampleStruct()
        assert(Utility.toString(entity) == "\(type(of: entity))")
    }
    
    
    func testHasProtocol() throws {
        let entity = ExampleStruct()
        let protocolType = ThisProtocol.Protocol.self
        
        // 是否是指定协议
        assert(ExampleStruct.self is ThisProtocol.Type)
        assert((entity.self as? ThisProtocol) != nil)
        
        // 是指定协议后调用其协议函数
        if let x = (entity.self as? ThisProtocol) {
            x.go()
        }
    }
    
    
    
}

protocol ThisProtocol {
    func go()
}

struct ExampleStruct: ThisProtocol {
    func go() {
        print("Go")
    }
}
