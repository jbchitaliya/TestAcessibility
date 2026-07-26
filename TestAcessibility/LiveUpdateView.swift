//
//  LiveUpdateView.swift
//  TestAcessibility
//
//  Created by Jignesh Chitaliya on 25/07/26.
//


import SwiftUI

struct LiveUpdateView: View {
    @State private var statusMessage = "System Idle"

    var body: some View {
        VStack(spacing: 20) {
            Text(statusMessage)
                .font(.title)
                // Highlights this view as a live region
                

            Button("Download File") {
                statusMessage = "Downloading started..."
                
                // Simulate network delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    statusMessage = "Download complete!"
                }
            }
        }
    }
}

