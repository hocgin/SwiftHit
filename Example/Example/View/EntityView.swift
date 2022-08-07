//
//  EntityView.swift
//  Example
//
//  Created by hocgin on 2022/8/7.
//

import SwiftUI
import CoreHit

struct EntityView: View {
    var entity: Codable
    
    var body: some View {
        Text("\(entity.toJSONString())")
    }
}

struct EntityView_Previews: PreviewProvider {
    static var previews: some View {
//        EntityView(entity: "")
        Text("Hi")
    }
}
