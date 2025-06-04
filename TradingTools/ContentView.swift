//
//  ContentView.swift
//  TradingTools
//
//  Created by 史源喆 on 6/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = RecapModel()
    @StateObject private var planStore = TradePlanStore()
    
    var body: some View {
        TabView {
            StepEditor(title: "看新闻", text: $model.news)
                .tabItem { Label("新闻", systemImage: "newspaper") }
            StepEditor(title: "看大盘", text: $model.market)
                .tabItem { Label("大盘", systemImage: "chart.line.uptrend.xyaxis") }
            StepEditor(title: "看热点", text: $model.topic)
                .tabItem { Label("热点", systemImage: "flame") }
            StepEditor(title: "看持仓", text: $model.holdings)
                .tabItem { Label("持仓", systemImage: "briefcase") }
            StepEditor(title: "选股", text: $model.selection)
                .tabItem { Label("选股", systemImage: "list.bullet.rectangle") }

            PlanListView(store: planStore)
                .tabItem { Label("计划", systemImage: "list.bullet.clipboard") }

            StepEditor(title: "复盘", text: $model.plan)
                .tabItem { Label("复盘", systemImage: "calendar") }
        }
    }
}

#Preview {
    ContentView()
}
