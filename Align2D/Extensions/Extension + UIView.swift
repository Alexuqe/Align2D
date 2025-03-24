import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        view.forEach { subview in
            self.addSubview(subview)
        }
    }
}
