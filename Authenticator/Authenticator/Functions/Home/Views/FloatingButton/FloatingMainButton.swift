//
//  FloatingMainButton.swift
//  ColorNote
//
//  Created by Trung Vo on 04/06/2024.
//

import SwiftUI
import Pow

struct MainButton: View {

    var imageName: String
    var color: Color
    var width: CGFloat = 50
//    @Binding var isJumping: Bool
    
    var body: some View {
        plusButton
//            .conditionalEffect(.repeat(.jump(height: 40), every: .seconds(5)), condition: isJumping)
    }
    
    var plusButton: some View {
        ZStack {
            // gradient colors
            LinearGradient(gradient: Gradient(colors: [
                Color.mainBlue,
                Color.mainBlue.opacity(0.6)
            ]),
                           startPoint: .top,
                           endPoint: .bottom)
            .frame(width: width, height: width)
                .cornerRadius(width / 2)
                .shadow(color: color.opacity(0.5),
                        radius: 15,
                        x: 0,
                        y: 15)
            Image(systemName: imageName)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(.white)
        }
    }
}
