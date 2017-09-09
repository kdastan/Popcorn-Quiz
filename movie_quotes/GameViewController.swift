//
//  GameViewController.swift
//  movie_quotes
//
//  Created by Apple on 04.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import SVProgressHUD
import YLProgressBar

class GameViewController: UIViewController {
    
    let buttonWidth = (Screen.width / 2) - 40
    
    var list: [[String: String]]!
    
    var i = 0
    var score = 0
    
    var answers: [String] = []
    var realAnswer = ""

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "playBackground")
        return image
    }()
    
    lazy var questionBackground: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "QuestionLabel")
        return image
    }()
    
    lazy var blurImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var buttonA: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(button1), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    lazy var buttonB: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(button2), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonC: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(button3), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonD: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(button4), for: .touchUpInside)
        return button
    }()
    
    lazy var wheel: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "film-reel")
        return image
    }()
    
    lazy var scoreLabel: UILabel = {
        let score = UILabel()
        score.textColor = .white
        score.text = "0"
        return score
    }()
    
    lazy var progressBar: YLProgressBar = {
        let progressBar = YLProgressBar()
        return progressBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraint()
        
        SVProgressHUD.show()
        
        fetchFromFirebase(completion: {(result) in
            SVProgressHUD.dismiss()
            
            guard let _ = result else {
                self.networkErrorAlert()
                return
            }
            
            self.newQuestionSetup()
        })
    }
    
    func setupViews() {
        edgesForExtendedLayout = []
        
        [imageView, questionBackground, wheel, scoreLabel, label, buttonA, buttonB, buttonC, buttonD, blurImageView, progressBar].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraint() {
    
        imageView <- [
            Top(0),
            Left(0),
            Width(Screen.width),
            Height(Screen.height)
        ]
        
        questionBackground <- [
            Left(35),
            Right(35),
            Top(35),
            Height(Screen.height * 0.5)
        ]
        
        wheel <- [
            Top(16),
            Left(16),
            Size(30)
        ]
        
        scoreLabel <- [
            CenterY(0).to(wheel, .centerY),
            Left(10).to(wheel, .right)
        ]
        
        blurImageView <- [
            Top(0),
            Left(0),
            Width(Screen.width),
            Height(Screen.height)
        ]
        
        label <- [
            Left(100).to(questionBackground, .left),
            Right(100).to(questionBackground, .right),
            Top(25).to(questionBackground, .top),
            Bottom(25).to(questionBackground, .bottom)
        ]
        
        buttonA <- [
            Top(22).to(questionBackground, .bottom),
            Left(0).to(questionBackground, .left),
            Width(buttonWidth),
            Height(Screen.height * 0.1)
        ]
        
        buttonB <- [
            Top(22).to(questionBackground, .bottom),
            Right(0).to(questionBackground, .right),
            Width(buttonWidth),
            Height(Screen.height * 0.1)
        ]
        
        buttonC <- [
            Top(16).to(buttonA, .bottom),
            Left(0).to(buttonA, .left),
            Width(buttonWidth),
            Height(Screen.height * 0.1)
        ]
        
        buttonD <- [
            Top(16).to(buttonB, .bottom),
            Right(0).to(buttonB, .right),
            Width(buttonWidth),
            Height(Screen.height * 0.1)
        ]
        
        progressBar <- [
            Top(0),
            CenterX(0),
            Width(Screen.width),
            Height(10)
        ]
    }
    
    func button1() {
        variantPressed(buttonAnswer: (buttonA.titleLabel?.text)!)
    }
    
    func button2() {
        variantPressed(buttonAnswer: (buttonB.titleLabel?.text)!)
    }
    
    func button3() {
        variantPressed(buttonAnswer: (buttonC.titleLabel?.text)!)
    }
    
    func button4() {
        variantPressed(buttonAnswer: (buttonD.titleLabel?.text)!)
    }

    func variantPressed(buttonAnswer: String) {
        if buttonAnswer == realAnswer {
            print("Correct")
            nextQuestion()
        } else {
            gameOverEffect()
            print("Not correct")
        }
    }
    
    //MARK: Fetch quotes from fb
    func fetchFromFirebase(completion: @escaping (Bool?) -> Void) {
            Quotes.fetchQuotes { (list) in
                guard let _ = list else {
                    completion(nil)
                    return
                }
                self.list = list
                completion(true)
        }
    }
    
    //MARK: Network connection error
    func networkErrorAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Question setup
    func newQuestionSetup() {
        answers.removeAll()
        
        var countAnswer = 0
        let randomQuote = Int(arc4random_uniform(99))
        
        label.text = list[randomQuote]["Quote"]! + list[randomQuote]["Name"]!
        realAnswer = list[randomQuote]["Name"]!
        
        answers.append(realAnswer)
        
        while countAnswer != 3 {
            let randomAnswer = Int(arc4random_uniform(99))
            let answer = list[randomAnswer]["Name"]!
            
            if !answers.contains(answer) {
                answers.append(answer)
                countAnswer += 1
            }
        }
    
        answers.shuffle()
        buttonA.setTitle(answers[0], for: .normal)
        buttonB.setTitle(answers[1], for: .normal)
        buttonC.setTitle(answers[2], for: .normal)
        buttonD.setTitle(answers[3], for: .normal)
        
        countAnswer = 0
    }
    
    //MARK: Game over effect
    func gameOverEffect() {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = UIScreen.main.bounds
        blurImageView.addSubview(blurView)
        
        buttonA.isEnabled = false
        buttonB.isEnabled = false
        buttonC.isEnabled = false
        buttonD.isEnabled = false
    }
    
    func nextQuestion() {
        score += 1
        scoreLabel.text = String(score)
        
        //Reload Questions Here
        
        i += 1
        newQuestionSetup()
    }

}
