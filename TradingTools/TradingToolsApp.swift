//
//  TradingToolsApp.swift
//  TradingTools
//
//  Created by 史源喆 on 6/4/25.
//

import SwiftUI

@main
struct TradingToolsApp: App {
    let persistence = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
