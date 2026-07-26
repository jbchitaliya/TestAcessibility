//
//  OrderRow.swift
//  TestAcessibility
//
//  Created by Jignesh Chitaliya on 25/07/26.
//
import SwiftUI

struct Order: Identifiable {
    let id = UUID()
    let name: String
}

struct OrderRow: View {
    let order: Order
    let onDelete: () -> Void
    @State private var offset: CGFloat = 0

    var body: some View {
        Text(order.name)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 { offset = value.translation.width }
                    }
                    .onEnded { value in
                        if value.translation.width < -100 { onDelete() }
                        offset = 0
                    }
            )
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            .accessibilityAction(named: "Delete") {
                onDelete()
            }
    }
}

#Preview {
    OrderRow(order: Order(name: "Test Order"), onDelete: {})
}
