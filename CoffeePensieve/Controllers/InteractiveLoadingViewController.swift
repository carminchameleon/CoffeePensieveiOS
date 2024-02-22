//
//  InteractiveLoadingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 17/2/2024.
//

import UIKit
import SwiftUI

class InteractiveLoadingViewController: UIViewController {
   
    var pensieveView = PensieveView()

    var waterImage: UIImageView = {
        let imageName = "water1"
        let loadingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: loadingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Your memory is being \n put into your pensieve..."
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = 0
        return label
    }()
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        super.viewWillAppear(animated)
    
    }

    override func viewDidAppear(_ animated: Bool) {

        let position = pensieveView.layer.position.y
        let labelPosition = loadingLabel.layer.position.y
        
        let labelAnimation = CAKeyframeAnimation(keyPath: "position.y")
        labelAnimation.values = [labelPosition + 15, labelPosition]
        labelAnimation.keyTimes = [0, 1]
        labelAnimation.duration = 1.5
        

        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position.y")
        positionAnimation.values = [position + 15, position]
        positionAnimation.keyTimes = [0, 1]
        positionAnimation.duration = 1.5
        
        pensieveView.layer.add(positionAnimation, forKey: "movePensieve")
        waterImage.layer.add(positionAnimation, forKey: "movePensieve")
        loadingLabel.layer.add(labelAnimation, forKey: "moveLabel")
        updateAnimation()
    }

    @objc func updateAnimation() {
        // 1. 투명도를 1에서 0으로 1초간 바꾼다. (fade out)
        UIView.animate(withDuration: 1.5) {
            self.loadingLabel.alpha = 1
            self.waterImage.alpha = 0
        } completion: { (finished) in
            // fade out이 된 상태 (아무것도 안보이는 상태) 에서,
            // 이미지를 교체한다. (아무것도 안보이기 때문에 이미지 튕김이 없음)
            self.waterImage.image = UIImage(named: "water3")
            // 그 다음, Opacity를 다시 0에서 1로 1초간 바뀌게 하면
            // 바뀐 이미지로 투명도가 조절되어 보인다.
            UIView.animate(withDuration: 1.5) {
                self.waterImage.alpha = 1

            }
        }
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(pensieveView)
        pensieveView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pensieveView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pensieveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pensieveView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            pensieveView.heightAnchor.constraint(equalTo: pensieveView.widthAnchor, multiplier: 1)
        ])
        
        view.addSubview(waterImage)
        waterImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            waterImage.leadingAnchor.constraint(equalTo: pensieveView.leadingAnchor, constant: 30),
            waterImage.trailingAnchor.constraint(equalTo: pensieveView.trailingAnchor, constant: -30),
            waterImage.topAnchor.constraint(equalTo: pensieveView.topAnchor, constant: 30),
            waterImage.bottomAnchor.constraint(equalTo: pensieveView.bottomAnchor, constant: -30),
        ])
        
        view.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: pensieveView.bottomAnchor, constant: 36),
            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loadingLabel.heightAnchor.constraint(equalToConstant: ContentHeight.buttonHeight)
        ])
    }
    
    
}


#Preview {
    let vc = InteractiveLoadingViewController()
    return vc
}


extension UIImageView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
