//
//  SettingsView.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: CounterViewModel
    private let valueBounds: ClosedRange<Int> = -1_000_000...1_000_000

    var body: some View {
        Form {
            Section(header: Text("범위")) {
                Stepper(
                    "최소값: \(viewModel.minValue)",
                    value: $viewModel.minValue,
                    in: valueBounds.lowerBound...min(
                        max(
                            viewModel.maxValue,
                            viewModel.minValue
                        ),
                        valueBounds.upperBound
                    )
                )
                Stepper(
                    "최대값: \(viewModel.maxValue)",
                    value: $viewModel.maxValue,
                    in: max(
                        min(
                            viewModel.minValue,
                            viewModel.maxValue
                        ),
                        valueBounds.lowerBound
                    )...valueBounds.upperBound
                )
                Button("현재 값을 최소값으로 설정") { viewModel.minValue = viewModel.count }
                Button("현재 값을 최대값으로 설정") { viewModel.maxValue = viewModel.count }
            }

            Section(header: Text("증가/감소 폭")) {
                Stepper(
                    "step: \(viewModel.step)",
                    value: $viewModel.step,
                    in: 1...max(1, (viewModel.maxValue - viewModel.minValue))
                )
            }

            Section(header: Text("경계 동작")) {
                Toggle("경계에서 순환(wrap around)", isOn: $viewModel.wrapAround)
                if !viewModel.wrapAround {
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
                    viewModel.count = viewModel.minValue
                    viewModel.step = 1
                    viewModel.minValue = 0
                    viewModel.maxValue = 10
                    viewModel.wrapAround = false
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
        .environmentObject(CounterViewModel(service: LocalCounterService()))
}
