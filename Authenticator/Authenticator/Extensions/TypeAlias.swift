//
//  TypeAlias.swift
//  ColorNote
//
//  Created by Trung Vo on 05/06/2024.
//

import Foundation

typealias ActionHandler = () -> Void
typealias Completion<T> = (_ sender: T) -> Void
