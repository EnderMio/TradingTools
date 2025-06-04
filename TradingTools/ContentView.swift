//
//  ContentView.swift
//  TradingTools
//
//  Created by 史源喆 on 6/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var planStore = PlanStore(context: PersistenceController.shared.container.viewContext)
    @State private var holdings: String = ""
    
    var body: some View {
        TabView {
            NavigationStack {
                PlanListView(store: planStore)
            }
            .tabItem { Label("计划", systemImage: "list.bullet.clipboard") }

            NavigationStack {
                HoldingsView(text: $holdings)
            }
            .tabItem { Label("持仓", systemImage: "briefcase") }

            NavigationStack {
                TradeRecordListView()
            }
            .tabItem { Label("记录", systemImage: "chart.bar") }

            NavigationStack {
                TradeLogListView()
            }
            .tabItem { Label("日志", systemImage: "book") }
        }
        .tint(.purple)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
