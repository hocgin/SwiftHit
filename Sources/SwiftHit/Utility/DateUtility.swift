//
//  File.swift
//
//
//  Created by hocgin on 2024/1/21.
//

import Foundation

public enum DateUtility {
    public static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}
