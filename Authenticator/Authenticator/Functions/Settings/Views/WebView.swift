//
//  WebView.swift
//  ColorNote
//
//  Created by Trung Vo on 6/24/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


struct WebViewContainer: View {
    let url: URL
    let title: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textBlack)
                    .padding()
                // dismiss button with an X
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .foregroundColor(.textBlack)
                        .padding()
                }
            }
            .background(Color.lightGrayBackground)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
            WebView(url: url)
        }
        .background(Color.lightGrayBackground)
        .ignoresSafeArea()
    }
}
