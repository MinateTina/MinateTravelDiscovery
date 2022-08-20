//
//  TileModifier.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/25/22.
//

import SwiftUI

struct TileModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .background(Color("tileBackground"))
            .cornerRadius(5)
//            .shadow(color: .gray, radius: 3, x: 0.0, y: 2)
            .shadow(color: .init(.sRGB, white: 0.8, opacity: colorScheme == .light ? 1: 0), radius: 3, x: 0, y: 2)
    }
}


