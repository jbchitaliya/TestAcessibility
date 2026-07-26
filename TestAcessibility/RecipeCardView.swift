//
//  RecipeCardView.swift
//  TestAcessibility
//
//  Created by Jignesh Chitaliya on 25/07/26.
//
import SwiftUI

struct Recipe {
    let title: String
    let imageName: String
    let rating: Int
    let cookTimeMinutes: Int
}

struct RecipeCardView: View {
    let recipe: Recipe
    @State private var isFavorite = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var qty = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(recipe.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
                .accessibilityHidden(true)

            if dynamicTypeSize.isAccessibilitySize {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.title)
                        .font(.headline)
                        .lineLimit(3)
                    favoriteButton
                }
            } else {
                HStack{
                    Text(recipe.title)
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                    Spacer()
                    favoriteButton
                }
            }
            ratingRow
            QuantityStepper(quantity: $qty)
            DeliveryProgressView(status: .preparing)
            LiveUpdateView()
            
        }
        .accessibilityElement(children: .contain)
        .padding()
    }
    
    private var ratingRow: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { i in
                Image(systemName: i < recipe.rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
            Text("\(recipe.cookTimeMinutes) min")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(recipe.rating) out of 5 stars. \(recipe.cookTimeMinutes) minutes to cook.")
    }
    
    private var favoriteButton: some View {
        Button{
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    RecipeCardView(recipe: Recipe(title: "Delicious Pasta", imageName: "pasta", rating: 4, cookTimeMinutes: 30))
}
