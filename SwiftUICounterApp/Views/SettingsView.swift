//
//  SettingsView.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: CounterStore

    var body: some View {
        Form {
            Section(header: Text("범위")) {
                Stepper("최소값: \(store.minValue)", value: $store.minValue, in: -10000...store.maxValue)
                Stepper("최대값: \(store.maxValue)", value: $store.maxValue, in: store.minValue...10000)
                Button("현재 값을 최소값으로 설정") { store.minValue = store.count }
                Button("현재 값을 최대값으로 설정") { store.maxValue = store.count }
            }

            Section(header: Text("증가/감소 폭")) {
                Stepper("step: \(store.step)", value: $store.step, in: 1...max(1, (store.maxValue - store.minValue)))
            }

            Section(header: Text("경계 동작")) {
                Toggle("경계에서 순환(wrap around)", isOn: $store.wrapAround)
                if !store.wrapAround {
                    Text("최소/최대에서 더 이동하려고 하면 값이 고정됩니다.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    Text("최대에서 + 하면 최소로, 최소에서 - 하면 최대로 순환합니다.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button(role: .destructive) {
                    store.count = store.minValue
                    store.step = 1
                    store.minValue = 0
                    store.maxValue = 10
                    store.wrapAround = false
                } label: {
                    Text("설정 초기화")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack { SettingsView() }
        .environmentObject(CounterStore())
}
