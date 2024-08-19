import SwiftUI

struct CodeCardView: View {
    
    let token: Token
    @Binding var totp: String
    @Binding var timeRemaining: Int
    
    @State private var isBannerPresented: Bool = false
    
    var body: some View {
        Button {
            UIPasteboard.general.string = totp
            AlertKitHelper.show(title: formattedTotp, 
                                subtitle: "Code has been copied to your clipboard",
                                icon: .done,
                                style: .iOS16AppleMusic)
        } label: {
            mainView
        }
    }
    
    private var mainView: some View {
        HStack(spacing: 16) {
            issuerImage
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(verbatim: token.displayIssuer)
                        .font(.headline)
                    Text(verbatim: token.displayAccountName)
                        .font(.footnote)
                        .foregroundStyle(.textGray)
                }
                Text(verbatim: formattedTotp)
                    .font(.system(size: 30, weight: .bold).monospacedDigit())
            }
            .foregroundStyle(.textBlack)
            .contentShape(Rectangle())
            Spacer()
            ZStack {
                Circle().stroke(gradientView.opacity(0.3), lineWidth: 2.5)
                Arc(startAngle: .degrees(-90), endAngle: .degrees(endAngle), clockwise: true)
                    .stroke(lineWidth: 2.5)
                    .foregroundStyle(
                        gradientView
                    )
                Text(verbatim: timeRemaining.description)
                    .font(.system(size: 12, weight: .regular).monospacedDigit())
                    .foregroundStyle(
                        Color(uiColor: .textGray)
                    )
            }
            .frame(width: 32, height: 32)
        }
    }
    
    private var gradientView: LinearGradient {
        LinearGradient.mainGradientBlueOnly(startPoint: .topTrailing,
                                            endPoint: .topLeading)
    }
    
    private var formattedTotp: String {
        var code: String = totp
        switch code.count {
        case 6:
            code.insert(" ", at: code.index(code.startIndex, offsetBy: 3))
        case 8:
            code.insert(" ", at: code.index(code.startIndex, offsetBy: 4))
        default:
            break
        }
        return code
    }
    
    private var issuerImage: Image {
        let imageName: String = {
            let issuer: String = token.displayIssuer.lowercased()
            switch issuer {
            case "jetbrains account", "jetbrains+account":
                return "jetbrains"
            case "wordpress.com":
                return "wordpress"
            case "gab.com":
                return "gab"
            case "crowdin.com":
                return "crowdin"
            case "truthsocial.com":
                return "truthsocial"
            case "open collective":
                return "opencollective"
            default:
                return issuer
            }
        }()
        guard !(imageName.isEmpty) else { return Image("account-icon") }
        guard let uiImage: UIImage = UIImage(named: imageName) else { return Image("account-icon") }
        return Image(uiImage: uiImage)
    }
    
    private var endAngle: Double {
        return Double((30 - timeRemaining) * 12 - 89)
    }
}

private struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2.0, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}
