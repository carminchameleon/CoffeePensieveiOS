//
//  RecordLoadingView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/25.
//

import UIKit

final class RecordLoadingView: UIView {

    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isLoading = false {
        didSet {
            self.isHidden = !self.isLoading
            self.isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.backgroundColor = .white
        self.addSubview(self.backgroundView)
        self.addSubview(self.activityIndicatorView)
        
        
        NSLayoutConstraint.activate([
             self.backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
             self.backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
             self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
       ])
       
        NSLayoutConstraint.activate([
             self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
       ])
    
    }
}
