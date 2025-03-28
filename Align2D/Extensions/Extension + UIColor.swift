import UIKit

extension UIColor {

    var hexString: String {
        let components = cgColor.components
        let r = Float(components?[0] ?? 0.0)
        let g = Float(components?[1] ?? 0.0)
        let b = Float(components?[2] ?? 0.0)

        return String(
            format: "#%02LX%02LX%02LX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255))
    }

    convenience init(hexString: String) {
        var hexFormatted = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...255) / 255
        let green = CGFloat.random(in: 0...255) / 255
        let blue = CGFloat.random(in: 0...255) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
