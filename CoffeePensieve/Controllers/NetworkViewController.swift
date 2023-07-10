//
//  NetworkViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/06.
//

import UIKit

final class NetworkViewController: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .blue
            showAlert()
        }

    func showAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "A data connection is not currently allowed. Check your network status", preferredStyle: .alert)
        let endAction = UIAlertAction(title: "Finish", style: .destructive) { action in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        let confirmAction = UIAlertAction(title: "Check", style: .default) { _ in
            // 설정앱 켜주기
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        alertController.addAction(endAction)
        alertController.addAction(confirmAction)
    
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}
