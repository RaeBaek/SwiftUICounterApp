//
//  RootView.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CounterView()
            }
            .tabItem { Label("Counter", systemImage: "number") }

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape")}
        }
    }
}

#Preview {
    RootView()
        .environmentObject(CounterViewModel(service: LocalCounterService()))
}
