//
//  AppAuthenticationView.swift
//  Authenticator
//
//  Created by Trung Vo on 8/20/24.
//

import SwiftUI
import Lottie

struct AppAuthenticationView: View {
    @Binding var showLockScreen: Bool
    @State var showRetry: Bool = false
    
    var body: some View {
        VStack {
            Text("Face ID")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textBlack)
            Spacer()
            LottieView(animation: .named("face-id-authen"))
              .looping()
              .frame(width: 180, height: 180)
            Spacer()
            VStack(spacing: 4) {
                // title and description
                Text("Unlock with Face ID")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.textBlack)
                Text("Face ID is required to unlock Authenticator")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.textGray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            
            Spacer()
            if !showRetry {
                Button(action: {
                    BiometricAuthenticationService.shared.authenticateWithBiometrics(completion: { isSucces, errorMessage in
                        showLockScreen = !isSucces
                    })
                }, label: {
                    HStack {
                        // white-face-id-icon
                        Image("white-face-id-icon")
                            .resizable()
                            .frame(width: 28, height: 28)
                        Text("Unlock now")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.mainBlue)
                            .padding(.horizontal)
                    )
                })
            }
            
        }
        .background(Color.clear)
        .padding(.vertical, 40.minScaled)
        .onAppear {
            BiometricAuthenticationService.shared.authenticateWithBiometrics(completion: { isSucces, errorMessage in
                showLockScreen = !isSucces
            })
        }
    }
}
