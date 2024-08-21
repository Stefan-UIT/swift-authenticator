//
//  AppAuthenticationView.swift
//  Authenticator
//
//  Created by Trung Vo on 8/20/24.
//

import SwiftUI

struct AppAuthenticationView: View {
    @Binding var showLockScreen: Bool
    @State var showRetry: Bool = false
    
    var body: some View {
        VStack {
            Image("app-security")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 250)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .padding(.top, 100)
            if !showRetry {
                Button(action: {
                    BiometricAuthenticationService.shared.authenticateWithBiometrics(completion: { isSucces, errorMessage in
                        showLockScreen = !isSucces
                    })
                }, label: {
                    Image("retry")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.top, 40)
                })
            }
            Spacer()
            
        }
        .background(Color.clear)
        .onAppear {
            BiometricAuthenticationService.shared.authenticateWithBiometrics(completion: { isSucces, errorMessage in
                showLockScreen = !isSucces
            })
        }
    }
}
