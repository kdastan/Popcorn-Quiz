//
//  Attempts.swift
//  movie_quotes
//
//  Created by Apple on 17.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class Attempts: UIView {

    lazy var firstAttempt: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "like")
        return image
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "x 3"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Helvetica", size: 24)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [firstAttempt, label].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        label <- [
            CenterY(0),
            Right(0),
            Width(28)
        ]
        
        firstAttempt <- [
            CenterY(0),
            Right(5).to(label),
            Width(28),
            Height(24)
        ]
    }






}
