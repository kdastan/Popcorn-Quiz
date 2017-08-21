//
//  MenuViewController.swift
//  movie_quotes
//
//  Created by Apple on 20.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBAction func playButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toNextVC", sender: self)
    }
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
    }
    
    func buttonSetup() {
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
    }

}
