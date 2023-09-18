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
        backgroundColor = .white
        addSubview(backgroundView)
        addSubview(activityIndicatorView)
        
        
        NSLayoutConstraint.activate([
             backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
             backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
             backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
             backgroundView.topAnchor.constraint(equalTo: topAnchor),
       ])
       
        NSLayoutConstraint.activate([
             activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
             activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
       ])
    
    }
}
