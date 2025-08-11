//
//  CustomUISlider.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-10.
//

import SwiftUI

struct CustomUISlider: UIViewRepresentable {
    @Binding var value: Float
    let range: ClosedRange<Float>
    let step: Float
    let thumbColor: UIColor
    let minTrackColor: UIColor
    let maxTrackColor: UIColor

    init(
        value: Binding<Float>,
        in range: ClosedRange<Float>,
        step: Float = 1,
        thumbColor: UIColor = .white,
        minTrackColor: UIColor = .systemBlue,
        maxTrackColor: UIColor = .gray
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.thumbColor = thumbColor
        self.minTrackColor = minTrackColor
        self.maxTrackColor = maxTrackColor
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = range.lowerBound
        slider.maximumValue = range.upperBound
        slider.value = value
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.thumbTintColor = thumbColor
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        if uiView.value != value {
            uiView.value = value
        }
        uiView.minimumTrackTintColor = minTrackColor
        uiView.maximumTrackTintColor = maxTrackColor
        uiView.thumbTintColor = thumbColor
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, step: step)
    }

    class Coordinator: NSObject {
        var parent: CustomUISlider
        let step: Float

        init(_ parent: CustomUISlider, step: Float) {
            self.parent = parent
            self.step = step
        }

        @objc func valueChanged(_ sender: UISlider) {
            let steppedValue = (sender.value / step).rounded() * step
            let clampedValue = min(max(steppedValue, parent.range.lowerBound), parent.range.upperBound)

            if parent.value != clampedValue {
                parent.value = clampedValue
            }

            sender.value = clampedValue
        }
    }
}
