//
//  Result.swift
//  app-starter
//
//  Created by hocgin on 2024/1/18.
//

import Foundation
import SmartCodable

public struct Result<DataType: SmartCodable>: SmartCodable {
    public var success: Bool = false
    public var message: String?
    public var data: DataType?

    public init() {}
}
