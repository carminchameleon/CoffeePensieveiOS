//
//  AlertManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/08/21.
//

import UIKit

class AlertManager {
    private static func showTextAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
    
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
    
    static func showDeleteConfirmation(on vc: UIViewController, completion: @escaping (Bool) -> Void) {
        let button1 = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        let button2 = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }
        
        self.showButtonAlert(on: vc, title: "Delete Post", buttons: [button1, button2])
    }
}
