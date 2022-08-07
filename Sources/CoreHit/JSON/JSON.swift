//
//  File.swift
//  
//
//  Created by hocgin on 2022/8/7.
//

import Foundation
import SwiftUI

public protocol JSONObject where Self: Encodable { }

public extension JSONObject {
    func toJSONString() -> String {
        do {
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8) ?? ""
        }catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
