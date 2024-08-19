//
//  IconAndTextButton.swift
//  ColorNote
//
//  Created by Trung Vo on 04/06/2024.
//

import SwiftUI

struct IconAndTextButton: View {
    var imageName: String
    var buttonText: String
    let imageWidth: CGFloat = 22

    var body: some View {
        ZStack {
            Color.white
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .foregroundColor(Color.textBlack)
                    .frame(width: imageWidth, height: imageWidth)
                    .clipped()
                Spacer()
                Text(buttonText)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(Color.textBlack)
                Spacer()
            }
            .padding(.horizontal, 15)
        }
        .frame(width: 160, height: 45)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}
