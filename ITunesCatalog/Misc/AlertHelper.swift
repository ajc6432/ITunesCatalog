import UIKit

protocol AlertHelperProtocol {
    func showOKAlert(onViewController: UIViewController, withTitle title: String?, withMessage message: String?, completionHandler: AlertActionHandler?)
}

class AlertHelper: AlertHelperProtocol {

    static let shared = AlertHelper()

    func showOKAlert(onViewController viewController: UIViewController, withTitle title: String?, withMessage message: String?, completionHandler: AlertActionHandler?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: completionHandler)
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
