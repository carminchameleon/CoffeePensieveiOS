//
//  CommitCoffeeCollectionViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/03.
//

import UIKit

class CommitCoffeeCollectionViewCell: UICollectionViewCell {
   
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: frame.width * 0.25, y: 0, width: frame.width * 0.5, height: frame.width * 0.5 * 1.5)
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10 // 이미지 뷰 모서리를 둥글게 만듭니다.
        view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상을 검은색으로 설정합니다.
        view.layer.shadowOpacity = 0.5 // 그림자 투명도를 0.5로 설정합니다.
        view.layer.shadowOffset = CGSize(width: 0, height: 3) // 그림자의 위치를 조정합니다.
        view.layer.shadowRadius = 1 // 그림자의 크기를 설정합니다.
        view.layer.zPosition = -1
        return view
    }()
    
    lazy var imageLayer: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: frame.width * 0.5, height: frame.width * 0.5 * 1.5)
        view.backgroundColor =  UIColor.blue.withAlphaComponent(0.6)
        view.layer.zPosition = 10
        return view
    }()
    
    lazy var checkIcon: UIImageView = {
        let icon = UIImage(systemName: "checkmark")
        let imageView = UIImageView(image: icon!)
        imageView.tintColor = .white
        imageView.layer.zPosition = 20
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(checkIcon)
        addSubview(imageLayer)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
        
        checkIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkIcon.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            checkIcon.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        imageLayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageLayer.leadingAnchor.constraint(equalTo:leadingAnchor, constant: frame.width * 0.25),
            imageLayer.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -frame.width * 0.25),
            imageLayer.heightAnchor.constraint(equalToConstant: frame.width * 0.5 * 1.5)
        ])
    }
}
