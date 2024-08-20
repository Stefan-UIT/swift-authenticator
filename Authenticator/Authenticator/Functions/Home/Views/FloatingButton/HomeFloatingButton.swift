//
//  HomeFloatingButton.swift
//  ColorNote
//
//  Created by Trung Vo on 04/06/2024.
//

import SwiftUI
import FloatingButton
import Pow

struct HomeFloatingButton: View {
    @State var isJumping: Bool
    @State private var isOpen = false
    
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
        
        return FloatingButton(mainButtonView: MainButton(imageName: "plus", color: .mainBlue, width: 60).conditionalEffect(.repeat(.jump(height: 40.minScaled), every: .seconds(4)), condition: isJumping),
                       buttons: textButtons,
                       isOpen: $isOpen)
            .straight()
            .direction(.top)
            .alignment(.right)
            .spacing(12)
            .initialOpacity(0)
            .onChange(of: isOpen) { value in
                if value {
                    isJumping = false
                } 
//                else {
//                    isJumping = true
//                }
            }
//            .initialOffset(x: 100x0)
//            .animation(.spring())
    }
}
