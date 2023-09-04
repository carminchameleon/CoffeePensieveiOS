//
//  AlertManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/08/21.
//

import UIKit

class AlertManager {
    static func showTextAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }

    static func showTextAlert(on vc: UIViewController, title: String, message: String, actionTitle: String = "Okay", completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion()
        }
        alert.addAction(okayAction)
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}

extension AlertManager {
    static func showButtonAlert(on vc: UIViewController,title: String, message: String? = nil, buttons: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach({alert.addAction($0)})
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
