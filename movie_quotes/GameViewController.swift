//
//  GameViewController.swift
//  movie_quotes
//
//  Created by Apple on 04.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Alamofire
import SVProgressHUD

class GameViewController: UIViewController {
    
    let buttonWidth = (Screen.width / 2) - 40
    
    var model: [Model] = []
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
        return button
    }()
    
    lazy var buttonB: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(button2), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonC: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(button3), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonD: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraint()
        
        SVProgressHUD.show()
        fetch { (success) in
            self.questionSetup()
        }

    }
    
    func setupViews() {
        edgesForExtendedLayout = []
        
        [imageView, questionBackground, wheel, scoreLabel, label, buttonA, buttonB, buttonC, buttonD, blurImageView].forEach{
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
    
    func fetch(completion: @escaping (Bool) -> ()) {
        
        let url = "https://andruxnet-random-famous-quotes.p.mashape.com/?cat=movies&count=10"
        
        let headers = [
            "X-Mashape-Key": "9UO47e8LvRmshhVE8LGgNL8ew6AWp1f4ImGjsn19NTPqzDbIZ0",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.error != nil {
                SVProgressHUD.dismiss()
                self.networkErrorAlert()
                return
            }
            
            guard let json = response.result.value as? [Any] else {return}
            for i in 0..<json.count{
                let item = json[i] as? [String: String]
                let author = item?["author"] as? String
                let quote = item?["quote"] as? String
                let object = Model(author: author!, quote: quote!)
                self.model.append(object)
                print("\(self.model[i].author!) \(self.model[i].quote!)")
            }
            completion(true)
            SVProgressHUD.dismiss()
        }
        
        //self.model.removeAll()
    }
    
    func networkErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Bad internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func questionSetup() {
        
        answers.removeAll()
        
        label.text = model[i].quote
        var count = 0
        realAnswer = model[i].author
        answers.append(realAnswer)
        while count != 3 {
            var varA = Int(arc4random_uniform(9))
            var answer = model[varA].author
            var asd = answers.contains(answer!)
            if !answers.contains(answer!) {
                answers.append(answer!)
                count += 1
            }
        }
        count = 0
        answers.shuffle()
        buttonA.setTitle(answers[0], for: .normal)
        buttonB.setTitle(answers[1], for: .normal)
        buttonC.setTitle(answers[2], for: .normal)
        buttonD.setTitle(answers[3], for: .normal)
    }

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
        
        if i==9 {
            model.removeAll()
            SVProgressHUD.show()
            fetch { (success) in
                self.questionSetup()
            }
            i = 0
            return
        }
        i += 1
        questionSetup()
    }

}
