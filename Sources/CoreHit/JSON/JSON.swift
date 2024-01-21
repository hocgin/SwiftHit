//
//  File.swift
//
//
//  Created by hocgin on 2022/8/7.
//

import Foundation
import SwiftUI

public extension Encodable {
    func toJSONString() -> String {
        do {
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

public extension Decodable {
    static func parseObject(_ text: String) -> Self {
        do {
            return try JSONDecoder().decode(self, from: text.data(using: .utf8)!)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
