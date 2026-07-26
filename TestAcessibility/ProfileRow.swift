//
//  ProfileRow.swift
//  TestAcessibility
//
//  Created by Jignesh Chitaliya on 25/07/26.
//


import SwiftUI

struct ProfileRow: View {
    @State private var isFavorite = false

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .accessibilityHidden(true)
            VStack(alignment: .leading) {
                Text("John Doe")
                Text("Online")
            }
            .accessibilityElement(children: .combine)
            Spacer()
            Button(action: {
                isFavorite.toggle()
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
            }
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            .accessibilityHint("Double tap to toggle favorite status")
            .accessibilityAddTraits(.isButton)

            Button(action: {
                print("More options tapped")
            }) {
                Image(systemName: "ellipsis")
            }
            .accessibilityLabel("More options")
            .accessibilityHint("Double tap to see more options")
            .accessibilityAddTraits(.isButton)
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Profile row for John Doe, currently online")
        
    }
}

#Preview {
    ProfileRow()
}
