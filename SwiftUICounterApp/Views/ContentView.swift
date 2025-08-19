//
//  ContentView.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import SwiftUI

struct ContentView: View {
//    @EnvironmentObject var store: CounterStore

    var body: some View {
        VStack(spacing: 20) {
            Text("카운터")
                .font(.largeTitle).bold()

            Text("랜덤")
                .font(.system(size: 72, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .padding(.vertical, 8)

            ProgressView(value: progress)
                .padding(.horizontal)

        }
        .padding()
    }

    private var progress: Double {
        guard store.maxValue > store.minValue else { return 1.0 }
        return Double(store.count - store.minValue) / Double(store.maxValue - store.minValue)
    }
}

#Preview {
    NavigationStack { ContentView() }
        .environmentObject(CounterStore())

}
