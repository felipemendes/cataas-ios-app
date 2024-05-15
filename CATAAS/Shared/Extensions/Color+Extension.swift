//
//  Color+Extension.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let secondaryText = Color("SecondaryTextColor")
    let secondaryBackground = Color("SecondaryBackgroundColor")
    let errorColor = Color("ErrorColor")
}
