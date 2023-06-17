//
//  NetworkCheck.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/13.
//

import Foundation
import Network
import UIKit

final class NetworkCheck {
    static let shared = NetworkCheck()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConneted: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    

    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    // Network Monitoring 시작
      public func startMonitoring() {
          monitor.start(queue: queue)
          monitor.pathUpdateHandler = {[weak self] path in
              guard let weakSelf = self else { return }
              weakSelf.isConneted = path.status == .satisfied
              
              weakSelf.getConnectionType(path)
              
              if !weakSelf.isConneted {
                weakSelf.showNetworkVCOnRoot()
              }
              
          }
      }
    
    
    // Network Monitoring 종료
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    
    // Network 연결 타입
    private func getConnectionType(_ path: NWPath) {
        
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
    func showNetworkVCOnRoot() {
        DispatchQueue.main.async {
            
            let networkVC = NetworkViewController()
            networkVC.modalPresentationStyle = .fullScreen
            
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            guard let firstWindow = firstScene.windows.first else {
                return
            }
            
            let rootViewController = firstWindow.rootViewController
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "A data connection is not currently allowed. Check your network status", preferredStyle: .alert)
            let endAction = UIAlertAction(title: "Finish", style: .destructive) { action in
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(0)
                }
            }
                
            let confirmAction = UIAlertAction(title: "Setting", style: .default) { _ in
            
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
            alertController.addAction(endAction)
            alertController.addAction(confirmAction)
            rootViewController?.present(alertController, animated: true)
        }


    }

    
}

