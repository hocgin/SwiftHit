//
//  SwiftUIView.swift
//  
//
//  Created by hocgin on 2022/8/7.
//

import SwiftUI

struct NavigationHitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink { DatabaseView().environment(\.managedObjectContext, viewContext) } label: {
                    Label("【案例】数据库操作", systemImage: "plus")
                }
                NavigationLink { NetView().environment(\.managedObjectContext, viewContext) } label: {
                    Label("【案例】网络操作", systemImage: "plus")
                }
            }
        }
    }
    
}



struct NavigationHitView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHitView()
    }
}
