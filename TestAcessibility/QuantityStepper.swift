//
//  QuantityStepper.swift
//  TestAcessibility
//
//  Created by Jignesh Chitaliya on 25/07/26.
//
import SwiftUI

struct QuantityStepper: View {
    @Binding var quantity: Int
    let minQuantity = 1
    let maxQuantity = 99

    var body: some View {
        HStack(spacing: 16) {
            Button {
                decrement()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityHidden(true) // represented by the adjustable element below

            Text("\(quantity)")
                .font(.title3)
                .frame(minWidth: 30)
                .accessibilityHidden(true)
                
            Button {
                increment()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityHidden(true)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Quantity")
        .accessibilityValue("\(quantity)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: increment()
            case .decrement: decrement()
            default: break
            }
        }
    }

    private func increment() {
        guard quantity < maxQuantity else { return }
        quantity += 1
    }

    private func decrement() {
        guard quantity > minQuantity else { return }
        quantity -= 1
    }
}

#Preview {
    QuantityStepper(quantity: .constant(5))
}
