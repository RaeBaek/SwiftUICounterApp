//
//  SwiftUICounterAppApp.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import SwiftUI

@main
struct SwiftUICounterAppApp: App {
    @StateObject private var viewModel = CounterViewModel(service: LocalCounterService())

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel)
        }
    }
}
