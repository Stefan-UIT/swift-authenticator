//
//  HomeEmptyImage.swift
//  Authenticator
//
//  Created by Trung Vo on 18/08/2024.
//

import SwiftUI

struct HomeEmptyImage: View {
    @State private var bouncing = false
    
    var body: some View {
        Image("home-empty")
            .resizable()
            .scaledToFit()
            .frame(width: 250.minScaled, height: 250.minScaled)
            .padding(.leading, 40.minScaled)
            // add drop shadow

            .frame(maxHeight: 240.minScaled, alignment: bouncing ? .bottom : .top)
            .shadow(color: Color.onboardDarkBlue, radius: 30, x: 0, y: 5)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: bouncing)
            .onAppear {
                self.bouncing.toggle()
            }
    }
}

#Preview {
    HomeEmptyImage()
}
