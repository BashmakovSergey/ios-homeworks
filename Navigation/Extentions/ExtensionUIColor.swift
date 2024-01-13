import UIKit

public struct ColorPalette {
    
    static var textColor = UIColor.defaultColor(lightMode: .black, darkMode: .white)
    static var blackColor = UIColor.defaultColor(lightMode: .black, darkMode: .white)
    
//    static var labelColor = UIColor.defaultColor(lightMode: .systemGray6, darkMode: .black)

    static var resultTextColor = UIColor.defaultColor(lightMode: .green, darkMode: .systemGreen)
    static var whiteBackgroundColor = UIColor.defaultColor(lightMode: .white, darkMode: .black)
    static var lightGrayBackgroundColor = UIColor.defaultColor(lightMode: .lightGray, darkMode: .darkGray)
}

extension UIColor {
    static func defaultColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}
