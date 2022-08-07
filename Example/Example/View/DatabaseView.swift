//
//  DatabaseView.swift
//
//  Created by hocgin on 2022/8/7.
//

import SwiftUI
import SwiftHit


struct DatabaseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.timestamp, ascending: true)
    ], animation: .default)
    private var items: FetchedResults<Book>
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        EntityView(entity: item.viewModel)
                    } label: {
                        Text("Item at (item.id)")
                    }
                }
                .onDelete(perform: deleteItems)
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onClickAdd) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }.navigationTitle("数据库操作")
    }
    
    /**
     * 新增
     */
    private func onClickAdd() {
        withAnimation {
            print("测试")
            let _ = Book(context: viewContext)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    /**
     * 删除
     */
    private func deleteItems(offsets: IndexSet){
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct DatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseView()
    }
}
