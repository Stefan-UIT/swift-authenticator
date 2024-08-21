//
//  SettingView.swift
//  ColorNote
//
//  Created by Trung Vo on 6/24/24.
//

import SwiftUI
import Pow
import Lottie

struct SettingView: View {
    let tokens: [Token]
    
    @State private var isPlainTextActivityPresented: Bool = false
    @State private var isTXTFileActivityPresented: Bool = false
    @State private var isZIPFileActivityPresented: Bool = false
    
    @State private var selectedItem: SettingType?
    @State private var isPresentedView = false
    @State private var isFaceIDToggleEnable = false
    @State private var isiCloudToggleEnable = false
    
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
//                faceIDToggleView
//                icloudToggleView
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
                                            .frame(width: item.imageSize.width, height: item.imageSize.height)
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
            }
        }
        .onAppear {
            isFaceIDToggleEnable = BiometricAuthenticationService.shared.isAppLocked
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
}

// Views
private extension SettingView {
    var faceIDToggleView: some View {
        Toggle(isOn: $isFaceIDToggleEnable) {
            HStack {
                Text(BiometricAuthenticationService.shared.securityTitle)
                    .font(.system(size: 16, weight: .medium))
                LottieView(animation: .named("face-id"))
                  .looping()
                  .frame(width: 32, height: 32)
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .onChange(of: isFaceIDToggleEnable) { newValue in
            if BiometricAuthenticationService.shared.isAppLocked != newValue {
                BiometricAuthenticationService.shared.authenticateWithBiometrics { isSuccess, errorString in
                    if isSuccess {
                        isFaceIDToggleEnable = newValue
                        BiometricAuthenticationService.shared.setAppLocked(isEnable: newValue)
                    }
                }
            }
        }
    }
    
    var icloudToggleView: some View {
        Toggle(isOn: $isiCloudToggleEnable) {
            HStack(spacing: 0) {
                Text("Sync with iCloud")
                    .font(.system(size: 16, weight: .medium))
                LottieView(animation: .named("icloud"))
                  .looping()
                  .frame(width: 48, height: 48)
            }
            
        }
        .tint(.mainBlue)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}


// Actions
private extension SettingView {
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
