import UIKit

protocol AlertFactoryProtocol {
    func createAlert(message: String, completion: (() -> Void)?) -> UIAlertController
    func createConfirmationAlert(message: String, completion: @escaping (Bool) -> Void) -> UIAlertController
}

final class AlertControllerFactory: AlertFactoryProtocol {
    let userAction: UserAction
    let alertTitle: String?

    init(userAction: UserAction, alertTitle: String?) {
        self.userAction = userAction
        self.alertTitle = alertTitle
    }

    func createAlert(message: String, completion: (() -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(
            title: userAction.title,
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "Ok", style: .default) { vector in
            completion?()
        }

        alertController.addAction(okAction)
        return alertController
    }

    func createConfirmationAlert(message: String, completion: @escaping (Bool) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: userAction.title,
            message: message,
            preferredStyle: .actionSheet
        )

        let yesAction = UIAlertAction(title: "Да", style: .destructive) { _ in
            completion(true)
        }

        let noAction = UIAlertAction(title: "Назад", style: .cancel) { _ in
            completion(false)
        }

        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        return alertController
    }
}

// MARK: - UserAction
extension AlertControllerFactory {
    enum UserAction {
        case newVector
        case deleteVector

        var title: String {
            switch self {
            case .newVector:
                return "Сохранено"
            case .deleteVector:
                return "Удалить Вектор?"
            }
        }
    }
}
