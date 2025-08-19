//
//  CounterView.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import SwiftUI

struct CounterView: View {
    @EnvironmentObject var store: CounterStore

    var body: some View {
        VStack(spacing: 20) {
            Text("카운터")
                .font(.largeTitle).bold()

            Text("\(store.count)")
                .font(.system(size: 72, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .padding(.vertical, 8)

            ProgressView(value: progress)
                .padding(.horizontal)

            HStack(spacing: 16) {
                Button(action: store.decrement) {
                    Label("감소", systemImage: "minus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 44))
                }
                .buttonStyle(.plain)

                Button(action: store.reset) {
                    Text("리셋")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }

                Button(action: store.increment) {
                    Label("증가", systemImage: "plus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 44))
                }
                .buttonStyle(.plain)
            }

            Text("범위 \(store.minValue) - \(store.maxValue) · step \(store.step) · \(store.wrapAround ? "순환" : "경계 고정")")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

        }
        .padding()
        .navigationTitle("Counter")
    }

    private var progress: Double {
        guard store.maxValue > store.minValue else { return 1.0 }
        return Double(store.count - store.minValue) / Double(store.maxValue - store.minValue)
    }
}

#Preview {
    NavigationStack { CounterView() }
        .environmentObject(CounterStore())

}
