//
//  SwiftUI_CAMP__FinalProjectApp.swift
//  SwiftUI_CAMP__FinalProject
//
//  Created by ณัฐภัทร บัวเพชร on 16/6/2567 BE.
//

import SwiftUI
import SwiftData

@main
struct SwiftUI_Camp_TodolistApp: App {
    
    let container:ModelContainer
    
    init(){
        do{
            container = try ModelContainer(for: wantToGo.self)
        }catch{
            fatalError("Error")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(\.modelContext, container.mainContext)
    }
}
