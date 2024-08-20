//
//  SettingHeaderView.swift
//  Authenticator
//
//  Created by Trung Vo on 19/08/2024.
//

import SwiftUI

struct SettingHeaderView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image("black-arrow-left-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.textBlack)
                    .padding(.trailing, 4)
            }
            
            Text("Setting")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.textBlack)
            Spacer()
            PremiumLottieView()
        }
        .padding(.horizontal)
        .padding(.bottom, 4)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.lightGrayBackground)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}
