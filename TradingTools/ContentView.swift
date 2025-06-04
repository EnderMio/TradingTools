//
//  ContentView.swift
//  TradingTools
//
//  Created by 史源喆 on 6/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var planStore = TradePlanStore()
    @State private var holdings: String = ""
    
    var body: some View {
        TabView {
            PlanListView(store: planStore)
                .tabItem { Label("计划", systemImage: "list.bullet.clipboard") }

            StepEditor(title: "持仓", text: $holdings)
                .tabItem { Label("持仓", systemImage: "briefcase") }
        }
    }
}

#Preview {
    ContentView()
}
