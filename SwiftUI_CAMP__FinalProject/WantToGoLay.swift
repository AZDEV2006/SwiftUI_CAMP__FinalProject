//
//  WantToGoLay.swift
//  SwiftUI_CAMP__FinalProject
//
//  Created by ณัฐภัทร บัวเพชร on 16/6/2567 BE.
//

import SwiftUI
import SwiftData

struct WantToGoLay: View {
    @Environment(\.modelContext) var context
    @Query var toGo: [wantToGo]
    @State var showAddWantToGo: Bool = false
    
    var body: some View {
        NavigationStack {
            if toGo.isEmpty {
                Text("No data available")
                    .foregroundColor(.gray)
                    .italic()
                    .padding()
                .navigationTitle("List - Map")
            } else {
                List {
                    ForEach(toGo) { item in
                        WantToGoRow(Place: item)
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            context.delete(toGo[index])
                            try! context.save()
                        }
                    })
                }
                .navigationTitle("List - Map")
                Divider()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: wantToGo.self)
        
        var preview = wantToGo()

        container.mainContext.insert(preview)
        
        return WantToGoLay()
            .environment(\.modelContext, container.mainContext)
        
    } catch {
        fatalError("ERROR: \(error)")
    }
}
