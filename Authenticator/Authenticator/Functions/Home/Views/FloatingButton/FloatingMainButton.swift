//
//  FloatingMainButton.swift
//  ColorNote
//
//  Created by Trung Vo on 04/06/2024.
//

import SwiftUI

struct MainButton: View {

    var imageName: String
    var color: Color
    var width: CGFloat = 50

    var body: some View {
        ZStack {
            // gradient colors
            LinearGradient(gradient: Gradient(colors: [
                Color.mainBlue,
                Color.mainBlue.opacity(0.5)
            ]),
                           startPoint: .top,
                           endPoint: .bottom)
                .frame(width: width, height: width)
                .cornerRadius(width / 2)
                .shadow(color: color.opacity(0.3), 
                        radius: 15,
                        x: 0,
                        y: 15)
            Image(systemName: imageName)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(.white)
        }
    }
}
