//
//  DocketView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/17.
//

import UIKit

class DocketView: UIView {
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = FontStyle.subhead
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    
    let coffeeLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee"
        label.font = FontStyle.subhead
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let coffeeImage: UIImageView = {
         let view = UIImageView()
         view.image = UIImage(named: "Drink_Americano")
         view.frame = CGRect(x: 0, y: 0, width: 100, height: 140)
         view.contentMode = .scaleToFill
         view.layer.cornerRadius = 10 // 이미지 뷰 모서리를 둥글게 만듭니다.
         view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상을 검은색으로 설정합니다.
         view.layer.shadowOpacity = 0.5 // 그림자 투명도를 0.5로 설정합니다.
         view.layer.shadowOffset = CGSize(width: 0, height: 3) // 그림자의 위치를 조정합니다.
         view.layer.shadowRadius = 1 // 그림자의 크기를 설정합니다.
        return view
    }()
    
    let drinkLabel : UILabel = {
        let label = UILabel()
        label.text = "🔥HOT / AMERICANO"
        label.font = FontStyle.callOut
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var drinkStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [coffeeImage, drinkLabel ])
        st.spacing = 8
        st.axis = .vertical
        st.alignment = .center
        st.distribution = .fill
        return st
    }()
    
    
    let moodTitle: UILabel = {
        let label = UILabel()
        label.text = "Feeling"
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let moodImage : UILabel = {
        let label = UILabel()
        label.text = "🥳"
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        return label
    }()
    
    let moodLabel : UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var moodStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [moodImage, moodLabel])
        st.spacing = 8
        st.axis = .vertical
        st.alignment = .center
        st.distribution = .fill
        return st
    }()
    
    let detailTitle: UILabel = {
        let label = UILabel()
        label.text = "Detail"
        label.font = FontStyle.subhead

        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    
    let detailView: UILabel = {
      let label = UILabel()
      label.font = FontStyle.callOut
      label.numberOfLines = 0
        label.textColor = .white
      label.textAlignment = .left
      return label
    }()

    
    
    let tagTitle: UILabel = {
        let label = UILabel()
        label.text = "Tag"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let tags: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .left
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
        addSubview(createdAtLabel)
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createdAtLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18),
            createdAtLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            createdAtLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        addSubview(coffeeLabel)
        coffeeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coffeeLabel.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor, constant: 20),
            coffeeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            coffeeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        addSubview(drinkStack)
        drinkStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkStack.topAnchor.constraint(equalTo: coffeeLabel.bottomAnchor, constant: 12),
            drinkStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            drinkStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            drinkStack.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        coffeeImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeImage.widthAnchor.constraint(equalToConstant: 70),
            coffeeImage.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        addSubview(moodTitle)
        moodTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodTitle.topAnchor.constraint(equalTo: drinkStack.bottomAnchor, constant: 20),
            moodTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            moodTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        addSubview(moodStack)
        moodStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodStack.topAnchor.constraint(equalTo: moodTitle.bottomAnchor, constant: 12),
            moodStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            moodStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            moodStack.heightAnchor.constraint(equalToConstant: 115)
        ])
     
        
        addSubview(detailTitle)
        detailTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailTitle.topAnchor.constraint(equalTo: moodStack.bottomAnchor, constant: 20),
            detailTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            detailTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: detailTitle.bottomAnchor, constant: 12),
            detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            detailView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        
        addSubview(tagTitle)
        tagTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            tagTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        addSubview(tags)
        tags.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tags.topAnchor.constraint(equalTo: tagTitle.bottomAnchor, constant: 12),
            tags.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            tags.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
       
    }
    

    
}


extension UIView {
    func setGradient(color1:UIColor,color2:UIColor){
          let gradient: CAGradientLayer = CAGradientLayer()
          gradient.colors = [color1.cgColor,color2.cgColor]
          gradient.locations = [0.0 , 1.0]
          gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
          gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
          gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
      }
    
    func setGradient3Color(color1:UIColor, color2:UIColor, color3:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = bounds
      layer.insertSublayer(gradient, at: 0)
    }
}


//*** for horizontal gradient ***
//        // gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        // gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//        // *** for vertical gradient ***
//        // gradientLayer.locations = [0,1]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
