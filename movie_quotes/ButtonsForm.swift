//
//  ButtonsForm.swift
//  movie_quotes
//
//  Created by Apple on 15.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit

class ButtonsForm: UIButton {

    override public func layoutSubviews() {
        super.layoutSubviews()
        subviewSetup()
    }
    
    private func subviewSetup() {
        layer.cornerRadius = 4
        titleLabel?.adjustsFontSizeToFitWidth = true
        backgroundColor = .buttonColor
    }
    
}
