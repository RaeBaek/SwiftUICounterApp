//
//  CounterStore.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import Foundation
import Combine

final class CounterStore: ObservableObject {
    // 공개 상태
    @Published var count: Int = 0
    @Published var step: Int = 1
    @Published var minValue: Int = 0
    @Published var maxValue: Int = 10
    @Published var wrapAround: Bool = false

    // 내부
    private var cancellables = Set<AnyCancellable>()

    // 영속화 키
    private enum Key {
        static let store = "counter.store.v1"
    }

    // 저장용 스냅샷
    private struct Snapshot: Codable {
        let count: Int
        let step: Int
        let minValue: Int
        let maxValue: Int
        let wrapAround: Bool
    }

    init() {
        load()

        // 변경을 모아 debounce 후 저장
        Publishers.CombineLatest4($count, $step, $minValue, $maxValue)
            .combineLatest($wrapAround)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.save()
            }
            .store(in: &cancellables)

        // 제약 보장: min <= max, count는 범위 내
        $minValue
            .sink { [weak self] newMin in
                guard let self else { return }
                if newMin > maxValue { maxValue = newMin }
                clamp()
            }
            .store(in: &cancellables)

        $maxValue
            .sink { [weak self] newMax in
                guard let self else { return }
                if newMax < minValue { minValue = newMax }
                clamp()
            }
            .store(in: &cancellables)
    }

    // 동작
    func increment() {
        let next = count + step
        if next > maxValue {
            count = wrapAround ? minValue : maxValue
        } else {
            count = next
        }
    }

    func decrement() {
        let next = count + step
        if next < minValue {
            count = wrapAround ? maxValue : minValue
        } else {
            count = next
        }
    }

    func reset() {
        count = minValue
    }

    // 보조
    private func clamp() {
        if count < minValue { count = minValue }
        if count > maxValue { count = maxValue }
        if step <= 0 { step = 1 }
    }

    private func save() {
        let snap = Snapshot(
            count: count,
            step: step,
            minValue: minValue,
            maxValue: maxValue,
            wrapAround: wrapAround
        )

        if let data = try? JSONEncoder().encode(snap) {
            UserDefaults.standard.set(data, forKey: Key.store)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Key.store),
              let snap = try? JSONDecoder().decode(Snapshot.self, from: data) else { return }
        count = snap.count
        step = snap.step
        minValue = snap.minValue
        maxValue = snap.maxValue
        wrapAround = snap.wrapAround
        clamp()
    }

}
