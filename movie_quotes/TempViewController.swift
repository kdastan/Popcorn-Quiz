//
//  TempViewController.swift
//  movie_quotes
//
//  Created by Apple on 04.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import FirebaseAuth
import Firebase
import FirebaseDatabase

class TempViewController: UIViewController {

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        return image
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 40)
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        self.navigationController?.isNavigationBarHidden = true
        
        edgesForExtendedLayout = []
        view.addSubview(imageView)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        imageView <- [
            Top(0),
            Left(0),
            Width(Screen.width),
            Height(Screen.height)
        ]
        
        button <- [
            Bottom(75),
            CenterX(0),
            Width(127),
            Height(65)
        ]
    }
    
    func playPressed() {

//        let currentId = Auth.auth().currentUser?.uid
//        
//        Quotes.userExistsQuery(curID: currentId!) { (result) in
//            if result == false { print("Doesn't exists") }
//            
//            else { self. }
//        }
        
        navigationController?.pushViewController(GameViewController(), animated: true)
        
    }

}
