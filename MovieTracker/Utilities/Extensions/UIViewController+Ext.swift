import UIKit

extension UIViewController {
    @MainActor func presentErrorAlert(for error: any Error) {
        let title = NSLocalizedString("error_alert_title", comment: "Error alert title")
        let alertController = UIAlertController(
            title: title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        present(alertController, animated: true)
    }
}
