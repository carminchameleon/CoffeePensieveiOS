//
//  MoodSelectCollectionViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/08.
//

import UIKit

class MoodSelectCollectionViewCell: UICollectionViewCell {
    
    let moodLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let iconImage: UIImageView = {
        let emojiImage = "😇".image(pointSize: 100)
        let imageView = UIImageView(image: emojiImage)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubview(moodLabel)

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: frame.width * 0.5)
        ])

        containerView.addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            iconImage.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
            iconImage.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8)
        ])
        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            moodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            moodLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            moodLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
}
