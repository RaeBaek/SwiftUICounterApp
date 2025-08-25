//
//  CounterStore.swift
//  SwiftUICounterApp
//
//  Created by 백래훈 on 8/19/25.
//

import Foundation
import Combine

/// CounterService 프로토콜
protocol CounterService {
    func load() -> (count: Int, step: Int, min: Int, max: Int, wrap: Bool)?
    func save(count: Int, step: Int, min: Int, max: Int, wrap: Bool)
}

/// CounterService 프로토콜을 채택하는 LocalCounterService 구조체
struct LocalCounterService: CounterService {
    private enum Key { static let store = "counter.store.v1" }

    private struct SnapShot: Codable {
        let count: Int
        let step: Int
        let minValue: Int
        let maxValue: Int
        let wrapAround: Bool
    }

    func load() -> (count: Int, step: Int, min: Int, max: Int, wrap: Bool)? {
        guard let data = UserDefaults.standard.data(forKey: Key.store),
              let snap = try? JSONDecoder().decode(SnapShot.self, from: data) else { return nil }
        return (snap.count, snap.step, snap.minValue, snap.maxValue, snap.wrapAround)
    }

    func save(count: Int, step: Int, min: Int, max: Int, wrap: Bool) {
        let snap = SnapShot(
            count: count,
            step: step,
            minValue: min,
            maxValue: max,
            wrapAround: wrap
        )

        if let data = try? JSONEncoder().encode(snap) {
            UserDefaults.standard.set(data, forKey: Key.store)
        }
    }
}

final class CounterViewModel: ObservableObject {
    // 공개 상태
    @Published var count: Int = 0
    @Published var step: Int = 1
    @Published var minValue: Int = 0
    @Published var maxValue: Int = 10
    @Published var wrapAround: Bool = false

    // 내부
    private let service: CounterService
    private var cancellables = Set<AnyCancellable>()

    init(service: CounterService) {
        self.service = service

        load()
        setBindings()
    }

    // 변경을 모아 debounce 후 저장
    private func setBindings() {
        Publishers.CombineLatest4($count, $step, $minValue, $maxValue)
            .combineLatest($wrapAround)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.save() }
            .store(in: &cancellables)

        // 제약 보장: min <= max, count는 범위 내
        $minValue
            .sink { [weak self] newMin in
                guard let self else { return }
                if newMin > maxValue { maxValue = newMin }
                self.clamp()
            }
            .store(in: &cancellables)

        $maxValue
            .sink { [weak self] newMax in
                guard let self else { return }
                if newMax < minValue { minValue = newMax }
                self.clamp()
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
        let next = count - step
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
        service.save(count: count, step: step, min: minValue, max: maxValue, wrap: wrapAround)
    }

    private func load() {
        guard let data = service.load() else { return }
        count = data.count
        step = data.step
        minValue = data.min
        maxValue = data.max
        wrapAround = data.wrap

        clamp()
    }
}
