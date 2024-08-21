//
//  SettingView.swift
//  ColorNote
//
//  Created by Trung Vo on 6/24/24.
//

import SwiftUI
import Pow

struct SettingView: View {
    let tokens: [Token]
    
    @State private var isPlainTextActivityPresented: Bool = false
    @State private var isTXTFileActivityPresented: Bool = false
    @State private var isZIPFileActivityPresented: Bool = false
    
    @State private var selectedItem: SettingType?
    @State private var isPresentedView = false
    @State private var buttonScale = 1.0
    @State private var isShineEffect = false
    @State private var isToggleEnable = false
    
    private var tokensText: String {
        return tokens.map(\.uri).joined(separator: "\n") + "\n"
    }
    
    private let sections: [SettingSection] = [
        .init(title: "Export all key URIs", items: [.copyToClipboard,
                                       .exportPlainText,
                                       .exportTxtFile,
                                       .exportZipFile]),
        
        .init(title: "About", items: [.shareApp,
                                      .privacyPolicy,
                                      .termOfUse,
                                      .contactUs]
        ),
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                    ForEach(sections) { section in
                        Section(header:
                                    Text(section.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.textBlack)
                            .font(.system(size: 16, weight: .bold))
                        ) {
                            ForEach(section.items, id: \.self) { item in
                                Button {
                                    handleTap(on: item)
                                } label: {
                                    VStack {
                                        item.image
                                            .resizable()
                                            .frame(width: 32, height: 32)
//                                            .renderingMode(.template)
//                                            .font(.system(size: 22))
//                                            .foregroundColor(.textBlack)
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
                    }
                }
                .padding()
                Section(header:
                            Text("Security")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.textBlack)
                    .font(.system(size: 16, weight: .bold))
                ) {
                    Toggle(BiometricAuthenticationService.shared.securityTitle, isOn: $isToggleEnable)
                        .padding(.bottom)
                }
                .padding()
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                isShineEffect.toggle()
            }
            isToggleEnable = BiometricAuthenticationService.shared.isAppLocked
        }
        .onChange(of: isToggleEnable) { newValue in
            if BiometricAuthenticationService.shared.isAppLocked != newValue {
                BiometricAuthenticationService.shared.authenticateWithBiometrics { isSuccess, errorString in
                    if isSuccess {
                        isToggleEnable = newValue
                        BiometricAuthenticationService.shared.setAppLocked(isEnable: newValue)
                    }
                }
            }
        }
        .toolbar(.hidden)
        .background(Color.lightGrayBackground)
        .sheet(isPresented: $isPresentedView) {
            if let selectedItem = selectedItem {
                switch selectedItem {
                case .contactUs, .privacyPolicy, .termOfUse:
                    if let itemUrl = selectedItem.url,
                       let url = URL(string: itemUrl) {
                        WebViewContainer(url: url, title: selectedItem.title)
                    }
                case .exportPlainText:
                    ActivityView(activityItems: [tokensText]) {
                            isPresentedView = false
                    }
                case .exportTxtFile:
                    let url = txtFile()
                    ActivityView(activityItems: [url]) {
                        isPresentedView = false
                    }
                    case .exportZipFile:
                        let url: URL = zipFile()
                        ActivityView(activityItems: [url]) {
                            isPresentedView = false
                        }
                    
                default:
                    EmptyView()
                }
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
            handlingShareApp(urlString: item.url!)
        case .privacyPolicy, .termOfUse, .contactUs, .exportPlainText, .exportTxtFile, .exportZipFile:
            selectedItem = item
            isPresentedView = true
        case .copyToClipboard:
            UIPasteboard.general.string = tokensText
            AlertKitHelper.show(title: "Exported Accounts",
                                subtitle: "Copied all key URIs to Clipboard.",
                                icon: .done,
                                style: .iOS16AppleMusic)
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

struct SettingSection: Identifiable {
    var id = UUID()
    var title: String
    var items: [SettingType]
}

// Export
private extension SettingView {
    private func zipFile() -> URL {
            let imagesDirectoryName: String = "2FA-accounts-" + Date.currentDateText
            let imagesDirectoryUrl: URL = URL.tmpDirectoryUrl.appendingPathComponent(imagesDirectoryName, isDirectory: true)
            if !(FileManager.default.fileExists(atPath: imagesDirectoryUrl.path)) {
                    try? FileManager.default.createDirectory(at: imagesDirectoryUrl, withIntermediateDirectories: false)
            }
            _ = tokens.map({ saveQRCodeImage(for: $0, parent: imagesDirectoryUrl) })
            let zipFileName: String = imagesDirectoryName + ".zip"
            let zipFileUrl: URL = URL.tmpDirectoryUrl.appendingPathComponent(zipFileName, isDirectory: false)
            let coordinator = NSFileCoordinator()
            var err: NSError?
            coordinator.coordinate(readingItemAt: imagesDirectoryUrl, options: .forUploading, error: &err) { url in
                    try? FileManager.default.moveItem(at: url, to: zipFileUrl)
            }
            return zipFileUrl
    }
    
    private func saveQRCodeImage(for token: Token, parent parentDirectoryUrl: URL) -> URL? {
            guard let image: UIImage = generateQRCodeImage(from: token) else { return nil }
            let name: String = imageName(for: token)
            let fileUrl: URL = parentDirectoryUrl.appendingPathComponent(name, isDirectory: false)
            do {
                    try image.pngData()?.write(to: fileUrl)
            } catch {
                    return nil
            }
            return fileUrl
    }
    private func generateQRCodeImage(from token: Token) -> UIImage? {
            let filter = CIFilter.qrCodeGenerator()
            let data: Data = Data(token.uri.utf8)
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let transform: CGAffineTransform = CGAffineTransform(scaleX: 5, y: 5)
            guard let ciImage: CIImage = filter.outputImage?.transformed(by: transform) else { return nil }
            return UIImage(ciImage: ciImage)
    }
    private func imageName(for token: Token) -> String {
            var imageName: String = token.id + "-" + Date.currentDateText + ".png"
            imageName.insert("-", at: imageName.index(imageName.startIndex, offsetBy: token.secret.count))

            if let accountName: String = token.accountName, !accountName.isEmpty {
                    let prefix: String = accountName + "-"
                    imageName.insert(contentsOf: prefix, at: imageName.startIndex)
            }
            if let issuer: String = token.issuer, !issuer.isEmpty {
                    let prefix: String = issuer + "-"
                    imageName.insert(contentsOf: prefix, at: imageName.startIndex)
            }
            return imageName
    }
    
    private func txtFile() -> URL {
            let txtFileName: String = "2FA-accounts-" + Date.currentDateText + ".txt"
            let txtFileUrl: URL = URL.tmpDirectoryUrl.appendingPathComponent(txtFileName, isDirectory: false)
            try? tokensText.write(to: txtFileUrl, atomically: true, encoding: .utf8)
            return txtFileUrl
    }
}
