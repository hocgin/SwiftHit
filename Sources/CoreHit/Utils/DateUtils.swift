//
//  File.swift
//  
//
//  Created by hocgin on 2022/8/7.
//

import Foundation

public class DateUtils {
    public static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}



