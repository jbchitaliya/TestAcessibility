//
//  DeliveryProgressView.swift
//  TestAcessibility
//
//  Created by Jignesh Chitaliya on 25/07/26.
//

import SwiftUI
enum DeliveryStatus {
    case preparing
    case outForDelivery
    case delivered

    var progressValue: Double {
        switch self {
        case .preparing:
            return 0.33
        case .outForDelivery:
            return 0.66
        case .delivered:
            return 1.0
        }
    }

    var label: String {
        switch self {
        case .preparing:
            return "Preparing"
        case .outForDelivery:
            return "Out for Delivery"
        case .delivered:
            return "Delivered"
        }
    }
}

struct DeliveryProgressView: View {
    let status: DeliveryStatus // .preparing, .outForDelivery, .delivered

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ProgressView(value: status.progressValue)
                .tint(.blue)
            Text(status.label)
                .font(.subheadline)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Delivery Status")
        .accessibilityValue(status.label)
        .onChange(of: status) { _, newStatus in
            AccessibilityNotification.Announcement("order status updated to \(newStatus.label)").post()
        }
    }
}

#Preview {
    DeliveryProgressView(status: .preparing)
}
