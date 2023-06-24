//
//  Extensions.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/12.
//

import UIKit

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIButton{
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}

extension UITextField {
    func setupLeftSideImage(imageViewName:String) {
        // 아이콘 자체
        let imageView = UIImageView(frame: CGRect(x:2,y:2,width:20,height: 20))
        imageView.image = UIImage(systemName: imageViewName)
        // 아이콘 감싸는 것
        let imageViewContainerView = UIView(frame: CGRect(x:0, y:0, width: 32, height: 24))
        imageViewContainerView.addSubview(imageView)
        imageView.tintColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
        leftView = imageViewContainerView
        leftViewMode = .always
    }
    
    func setupRightSideImage(imageViewName:String, passed: Bool) {
        // 아이콘 자체
        let imageView = UIImageView(frame: CGRect(x:0,y:0,width:20,height: 20))
        imageView.image = UIImage(systemName: imageViewName)
        // 아이콘 감싸는 것
        let imageViewContainerView = UIView(frame: CGRect(x:0, y:0, width: 20, height: 20))
        imageViewContainerView.addSubview(imageView)
        
        rightView = imageViewContainerView
        rightViewMode = .whileEditing
        
        if passed {
            imageView.tintColor = UIColor.primaryColor400
        } else {
            imageView.tintColor = UIColor.redColor400
        }
    }
    

}