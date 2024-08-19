//
//  SettingHeaderView.swift
//  Authenticator
//
//  Created by Trung Vo on 19/08/2024.
//

import SwiftUI

struct SettingHeaderView: View {
    var body: some View {
        HStack {
            Text("More")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.textBlack)
                .padding(.leading)
            Spacer()
        }
        .padding(.bottom, 4)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.lightGrayBackground)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}
