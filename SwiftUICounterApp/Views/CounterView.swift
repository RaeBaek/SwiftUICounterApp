//
//  CounterView.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import SwiftUI

struct CounterView: View {
    @EnvironmentObject var viewModel: CounterViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("카운터")
                .font(.largeTitle).bold()

            Text("\(viewModel.count)")
                .font(.system(size: 72, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .padding(.vertical, 8)

            ProgressView(value: safeProgress.current, total: safeProgress.total)
                .padding(.horizontal)

            HStack(spacing: 16) {
                Button(action: viewModel.decrement) {
                    Label("감소", systemImage: "minus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 44))
                }
                .buttonStyle(.plain)

                Button(action: viewModel.reset) {
                    Text("리셋")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }

                Button(action: viewModel.increment) {
                    Label("증가", systemImage: "plus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 44))
                }
                .buttonStyle(.plain)
            }

            Text("범위 \(viewModel.minValue) - \(viewModel.maxValue) · step \(viewModel.step) · \(viewModel.wrapAround ? "순환" : "경계 고정")")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

        }
        .padding()
        .navigationTitle("Counter")
    }

    private var progress: Double {
        guard viewModel.maxValue > viewModel.minValue else { return 1.0 }
        return Double(viewModel.count - viewModel.minValue) / Double(viewModel.maxValue - viewModel.minValue)
    }

    private var safeProgress: (current: Double, total: Double) {
        let minV = Double(viewModel.minValue)
        let maxV = Double(viewModel.maxValue)
        var total = maxV - minV

        // total이 0 이하(동일값 등)일 때 경고 방지용 기본값
        if total <= 0 { return (1.0, 1.0) }

        // count를 안전 범위로 클램프
        let clamped = min(max(Double(viewModel.count), minV), maxV)
        let current = clamped - minV

        // 경계값이 살짝 엇갈리는 순간을 대비해 current를 0...total로 한 번 더 클램프
        return (current: min(max(current, 0.0), total), total: total)
    }
}

#Preview {
    NavigationStack { CounterView() }
        .environmentObject(CounterViewModel(service: LocalCounterService()))
}
