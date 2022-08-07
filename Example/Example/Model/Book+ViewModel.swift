//
//  BookModal.swift
//  Example
//
//  Created by hocgin on 2022/8/7.
//

import Foundation
import CoreHit


struct BookViewModel: Identifiable, JSONObject, Codable {
    var id = UUID()
    var timestamp: Date
//    public init(from decoder: Decoder) throws {
//        //
//    }
//    func encode(to encoder: Encoder) throws {
//        //
//    }
}

extension Book {
    var viewModel: BookViewModel {
        BookViewModel(
            timestamp: self.timestamp ?? Date()
        )
    }
}
