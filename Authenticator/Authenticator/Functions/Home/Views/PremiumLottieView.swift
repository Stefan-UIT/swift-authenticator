//
//  PremiumLottieView.swift
//  Authenticator
//
//  Created by Trung Vo on 20/08/2024.
//

import SwiftUI
import Lottie

struct PremiumLottieView: View {
    var size: CGSize = .init(width: 32, height: 32)
    
    var body: some View {
        Button {
            print("Present sub")
        } label: {
            LottieView(animation: .named("king-icon-lottie"))
              .looping()
              .frame(width: size.width, height: size.height)
        }
    }
}

#Preview {
    PremiumLottieView()
}
