//
//  File.swift
//  
//
//  Created by hocgin on 2022/8/7.
//

import Foundation

public struct HttpUtils {
    
    public static func isHttp(_ url: String) -> Bool {
        url.starts(with: "http") || url.starts(with: "https")
    }
    
}
