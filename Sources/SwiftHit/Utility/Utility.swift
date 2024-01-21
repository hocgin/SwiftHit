//
//  Utility.swift
//  app-starter
//
//  Created by hocgin on 2024/1/19.
//

import Foundation
import SmartCodable

public class Utility {
    class func classNameAsString(_ obj: Any) -> String {
        // prints more readable results for dictionaries, arrays, Int, etc
        return String(describing: type(of: obj))
    }

    public static func isHttp(_ url: String) -> Bool {
        url.starts(with: "http") || url.starts(with: "https")
    }

    /**
     * 比较对象是否是某个类
     */
    public static func hasType(_ obj: Any, ofType: Any.Type) -> Bool {
        type(of: obj) == ofType
    }

    /**
     * 获取对象类型的字符串
     */
    public static func toString<Value>(_ obj: Value) -> String {
        "\(type(of: obj))"
    }

    /**
     JSON String
     */
    public static func toJSONString(_ value: Any) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error converting to JSON string: \(error)")
        }
        return nil
    }
}
