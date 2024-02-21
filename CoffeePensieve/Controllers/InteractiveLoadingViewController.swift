//
//  InteractiveLoadingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 17/2/2024.
//

import UIKit
import SwiftUI

class InteractiveLoadingViewController: UIViewController {

//    lazy var pensieveStack: UIStackView = {
//        let st = UIStackView(arrangedSubviews: [pensieveView])
//        st.spacing = 0
//        st.axis = .vertical
//        st.alignment = .center
//        st.distribution = .fill
//        return st
//    }()
//    
//    
    var pensieveView = PensieveView()
    
    var imageView = UIImageView()

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
        return label
    }()
    
    var button = CustomButton(title: "add memory")

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
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position.y")
        positionAnimation.values = [position + 30, position]
        positionAnimation.keyTimes = [0, 1]
        positionAnimation.duration = 2
        
        pensieveView.layer.add(positionAnimation, forKey: "movePensieve")
        waterImage.layer.add(positionAnimation, forKey: "movePensieve")
        changeImage()
    }
   
    
    @objc func changeImage() {
        // 1. 투명도를 1에서 0으로 1초간 바꾼다. (fade out)
        UIView.animate(withDuration: 2) {
            self.waterImage.alpha = 0
        } completion: { (finished) in
            // fade out이 된 상태 (아무것도 안보이는 상태) 에서,
            // 이미지를 교체한다. (아무것도 안보이기 때문에 이미지 튕김이 없음)
            self.waterImage.image = UIImage(named: "water3")
            // 그 다음, Opacity를 다시 0에서 1로 1초간 바뀌게 하면
            // 바뀐 이미지로 투명도가 조절되어 보인다.
            UIView.animate(withDuration: 1) {
                self.waterImage.alpha = 1
            }
        }
    }
    
    
    func updateWaterImage() {
        UIView.transition(with: imageView, duration: 10.0, options: .transitionCrossDissolve, animations: {
            self.waterImage.layer.opacity = 1
            self.waterImage.image = UIImage(named: "water2")
        }, completion: nil)
    }
    
    
    @objc func updateImage() {
        self.waterImage.rotate()

        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
//            self.waterImage.layer.opacity = 0
            print("work first")
            
            let newImageName = "water1"
            let newImage = UIImage(named: newImageName)
            self.waterImage.image = newImage

            
        } completion: { completion in
            UIView.animate(withDuration: 0.5) {
                let newImageName = "water2"
                let newImage = UIImage(named: newImageName)
                self.waterImage.image = newImage
//                self.waterImage.layer.opacity = 1
            }
        }

    }
    
    func setUI() {
        view.backgroundColor = .white
   
//        view.addSubview(pensieveStack)
//        pensieveStack.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            pensieveStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            pensieveStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            pensieveStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
//            pensieveStack.heightAnchor.constraint(equalTo: pensieveStack.widthAnchor, multiplier: 1)
//        ])
        
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

class PensieveView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // MARK: - Octangle ( Stone )
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius: CGFloat = min(rect.width, rect.height) / 2
        // double.pi 하는 이유는 2파이가 360도를 계산하는 기준이라서
        let angleIncrement = CGFloat(Double.pi * 2 / Double(8))
        context.beginPath()
        
        for i in 0..<8 {
            // 꼭지점의 각도 계산
            //시작점을 기준으로 45도 그 다음은 90도 이런 식으로 증가해야함.
            let angle = angleIncrement * CGFloat(i)
            // 꼭지점의 x, y 좌표 계산
            let pointX = center.x + radius * cos(angle)
            let pointY = center.y + radius * sin(angle)
            
            if i == 0 {
                context.move(to: CGPoint(x: pointX, y: pointY))
            } else {
                context.addLine(to: CGPoint(x: pointX, y: pointY))
            }
        }
        
        context.closePath()
        context.clip()
        
        // MARK: - fill color
        let silverColors = [UIColor.silverGradient100.cgColor, UIColor.silverGradient200.cgColor] as CFArray
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: silverColors, locations: [0,1]) else { return }
        let startPoint = CGPoint(x: 0, y: 0) // 시작점을 설정합니다.
        let endPoint = CGPoint(x: 0, y: self.bounds.height) // 끝점을 설정합니다.
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
                
        
        // MARK: - Circle ( water )
        let circleRadius: CGFloat = (min(rect.width, rect.height) - 60) / 2
        let path = CGMutablePath()
        path.addArc(center: center, radius: circleRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        context.addPath(path)
        context.clip()
        
        let waterBlue = [UIColor.waterBlueGradient100.cgColor, UIColor.waterBlueGradient200.cgColor] as CFArray
        let locations: [CGFloat] = [0.0 , 1.0]
        guard let blueGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: waterBlue, locations: locations) else { return }

        // 그라디언트 시작점과 끝점 정의
        let circleStartPoint = CGPoint(x: center.x - circleRadius, y: center.y)
        let circleEndPoint = CGPoint(x: center.x + circleRadius, y: center.y)
        
        context.drawLinearGradient(blueGradient, start: circleStartPoint, end: circleEndPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
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
