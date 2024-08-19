//
//  SettingView.swift
//  ColorNote
//
//  Created by Trung Vo on 6/24/24.
//

import SwiftUI

struct SettingView: View {
    let items: [SettingType] = [.shareApp,
                                .privacyPolicy,
                                .termOfUse,
                                .contactUs]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var selectedItem: SettingType?
    @State private var showWebView = false
    @State private var buttonScale = 1.0
    
    var body: some View {
        VStack {
            SettingHeaderView()
            ScrollView() {
//                if !EntitlementManager.shared.hasPro {
//                    Button(action: {
//                        AppCoordinator.share?.presentSubscriptionView()
//                    }, label: {
//                        premiumBanner
//                            .padding(.horizontal)
//                            .scaleEffect(buttonScale)
//                    })
//                    .onAppear {
//                        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
//                            buttonScale = 0.98
//                        }
//                    }
//                    
//                }
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        Button {
                            handleTap(on: item)
                        } label: {
                            VStack {
                                Image(systemName: item.icon)
                                    .renderingMode(.template)
                                    .font(.system(size: 22))
                                    .foregroundColor(.textBlack)
                                    .padding(.bottom, 8)
                                Text(item.title)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.textBlack)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.bottom)
                    }
                }
                .padding()
            }
        }
        .background(Color.lightGrayBackground)
        .sheet(isPresented: $showWebView) {
            if let item = selectedItem, 
                let url = URL(string: item.url) {
                WebViewContainer(url: url, title: item.title)
            }
        }
    }
    
    func handlingShareApp(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        AppCoordinator.share?.visibleViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    private func handleTap(on item: SettingType) {
        switch item {
        case .shareApp:
            handlingShareApp(urlString: item.url)
        case .privacyPolicy, .termOfUse, .contactUs:
            selectedItem = item
            showWebView = true
        }
    }
    
//    var premiumBanner: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Upgrade to Premium")
//                    .font(.system(size: 18, weight: .bold))
//                    .foregroundColor(.white)
//                Text("Unlock 20+ Premium privileges")
//                    .font(.system(size: 14, weight: .regular))
//                    .foregroundColor(.white)
//            }
//            Spacer()
//            Text("Upgrade")
//                .font(.system(size: 14, weight: .bold))
//                .foregroundColor(.black)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 8)
//                .background(.white)
//                .clipShape(Capsule())
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(
//            Color(uiColor: .mainYellow)
//                .cornerRadius(12)
//        )
//        .padding(.top, 12)
//    }
}

#Preview {
    SettingView()
}
