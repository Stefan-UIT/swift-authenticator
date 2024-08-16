//
//  HomeFloatingButton.swift
//  ColorNote
//
//  Created by Trung Vo on 04/06/2024.
//

import SwiftUI
import FloatingButton

struct HomeFloatingButton: View {
    @State private var isOpen = false
    private let mainButton = MainButton(imageName: "plus", color: .mainBlue, width: 60)
    var didSelectOption: Completion<HomeActionE>?

    var body: some View {
        let textButtons = [
            IconAndTextButton(imageName: "qrcode.viewfinder", buttonText: "Scan QR Code").onTapGesture {
                    didSelectOption?(.addByScanning)
                    isOpen.toggle()
                }
            ,
            IconAndTextButton(imageName: "photo", buttonText: "Import from Photos").onTapGesture {
                    didSelectOption?(.addByQRCodeImage)
                    isOpen.toggle()
                }
            ,
            /*
             Button {
                     isFileImporterPresented = true
             } label: {
                     Label("Import from Files", systemImage: "doc.badge.plus")
             }
             */
            IconAndTextButton(imageName: "doc.badge.plus", buttonText: "Import from Files").onTapGesture {
                didSelectOption?(.addByFile)
                isOpen.toggle()
            }
            ,
            IconAndTextButton(imageName: "text.cursor", buttonText: "Enter Manually").onTapGesture {
                didSelectOption?(.addByManually)
                isOpen.toggle()
            }
        ]
        return FloatingButton(mainButtonView: mainButton,
                       buttons: textButtons,
                       isOpen: $isOpen)
            .straight()
            .direction(.top)
            .alignment(.right)
            .spacing(12)
            .initialOpacity(0)
//            .initialOffset(x: 1000)
//            .animation(.spring())
    }
}

#Preview {
    HomeFloatingButton()
}
