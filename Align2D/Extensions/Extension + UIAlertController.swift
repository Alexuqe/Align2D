import UIKit

extension UIViewController {
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertFactory = AlertControllerFactory(
            userAction: .newVector,
            alertTitle: nil
        )

        let alert = alertFactory.createAlert(message: message, completion: completion)
        present(alert, animated: true)
    }

    func showConfirmationAlert(vector: VectorEntity, message: String, completion: (() -> Void)? = nil) {
        let alertFactory = AlertControllerFactory(
            userAction: .deleteVector,
            alertTitle: nil
        )

        let alert = alertFactory.createConfirmationAlert(message: message) { confirmed in
            if confirmed {
                completion?()
            }
        }

        present(alert, animated: true)
    }
}
