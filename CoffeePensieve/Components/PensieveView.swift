//
//  PensieveView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 22/2/2024.
//

import UIKit

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
