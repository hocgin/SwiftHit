//
//  Result.swift
//  app-starter
//
//  Created by hocgin on 2024/1/18.
//

import Foundation
import SmartCodable

struct Result<DataType: SmartCodable>: SmartCodable {
    public var success: Bool = false
    public var message: String?
    public var data: DataType?
}

struct ExampleData: SmartCodable {
    public var id: String?
}
