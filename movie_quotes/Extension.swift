//
//  extension.swift
//  movie_quotes
//
//  Created by Apple on 21.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit

extension Array {
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<4
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

extension UIColor {
    static let buttonColor = UIColor(displayP3Red: 255/255, green: 133/255, blue: 0, alpha: 1)
}

