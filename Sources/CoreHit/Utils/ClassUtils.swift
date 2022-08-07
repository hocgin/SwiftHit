//
//  File.swift
//  
//
//  Created by hocgin on 2022/8/7.
//

import Foundation
import SwiftUI

public struct ClassUtils {
    
    /**
     * 比较对象是否是某个类
     */
    public static func hasType(_ obj: Any, ofType: Any.Type) -> Bool {
        (type(of: obj) == ofType)
    }
    
    /**
     * 获取对象类型的字符串
     */
    public static func toString<Value>(_ obj: Value) -> String {
        "\(type(of: obj))"
    }
    
    
}

