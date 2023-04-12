import SwiftUI

struct Theme {
    static func myBackgroundColor(forScheme scheme: ColorScheme) -> Color {
        let lightColor = Color(#colorLiteral(red: 0.9999999403953552, green: 1.0000001192092896, blue: 1.0000001192092896, alpha: 1.0))
        let darkColor = Color.black
        
        switch scheme {
        case .light : return lightColor
        case .dark : return darkColor
        @unknown default: return lightColor
        }
    }
}

public extension Color {
    
#if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
#else
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
#endif
}
