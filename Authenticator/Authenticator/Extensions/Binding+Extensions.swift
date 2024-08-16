//
//  Binding+Extensions.swift
//  ColorNote
//
//  Created by Trung Vo on 05/06/2024.
//

import SwiftUI

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
