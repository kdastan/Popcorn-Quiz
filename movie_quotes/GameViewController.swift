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
    
    var progress: Float = 0.04
    
    var seconds = 28
    
    var timer = Timer()
    var timer1 = Timer()
    
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
        progressBar.progressTintColor = .red
        progressBar.hideStripes = true
        progressBar.uniformTintColor = true
        progressBar.trackTintColor = .green
        progressBar.type = YLProgressBarType.flat
        progressBar.setProgress(0.8, animated: true)
        progressBar.setProgress(0, animated: false)
        return progressBar
    }()
    
    lazy var gameOverView: UIView = {
        let view = UIView()
        view.backgroundColor = .resultColor
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Helvetica", size: 24)
        label.textColor = .white
        return label
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setTitle("Menu", for: .normal)
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var playAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play again", for: .normal)
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(rePlayGame), for: .touchUpInside)
        return button
    }()
    
    
    lazy var HUDanimation: UIImageView = {
        let hud = UIImageView()
        hud.image = UIImage(named: "anim")
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraint()
        
        startGame()
    }
    
    func animStart() {
        UIView.animate(withDuration: 0.1) {
            self.HUDanimation.transform = self.HUDanimation.transform.rotated(by: CGFloat(M_PI_4))
        }
    }
    
    func startGame() {
        
        [self.buttonA, self.buttonB, self.buttonC, self.buttonD].forEach{
            $0.isEnabled = false
            $0.backgroundColor = .buttonColor
        }
        
        HUDanimation.isHidden = false

        timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animStart), userInfo: nil, repeats: true)
        
        gameOverView.isHidden = true
        
        scoreLabel.text = "0"
        
        progressBar.setProgress(0, animated: false)
        
        //SVProgressHUD.show()
        
        
        fetchFromFirebase(completion: {(result) in
            self.timer1.invalidate()
            self.HUDanimation.layer.removeAllAnimations()
            self.HUDanimation.isHidden = true
            //SVProgressHUD.dismiss()
            
            guard let _ = result else {
                self.networkErrorAlert()
                return
            }
            
            [self.buttonA, self.buttonB, self.buttonC, self.buttonD].forEach{
                $0.isEnabled = true
                $0.backgroundColor = .buttonColor
            }
            
            self.runTimer()
            self.newQuestionSetup()
            
        })

    }
    
    func setupViews() {
        edgesForExtendedLayout = []
        
        [imageView, questionBackground, wheel, scoreLabel, label, buttonA, buttonB, buttonC, buttonD, progressBar, HUDanimation,gameOverView].forEach{
            view.addSubview($0)
        }
        gameOverView.addSubview(resultLabel)
        gameOverView.addSubview(menuButton)
        gameOverView.addSubview(playAgainButton)
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
            Height(6)
        ]
        
        gameOverView <- [
            Width(230),
            Height(85),
            CenterX(0),
            CenterY(10)
        ]
        
        resultLabel <- [
            Top(15),
            CenterX(0),
            Height(20)
        ]
        
        menuButton <- [
            Left(10),
            Bottom(10),
            Width(100),
            Height(30)
        ]
        
        playAgainButton <- [
            Right(10),
            Bottom(10),
            Width(100),
            Height(30)
        ]
        
        HUDanimation <- [
            Center(0),
            Size(64)
        ]
        
        
    }
    
    func button1() {
        buttonA.backgroundColor = .red
        variantPressed(buttonAnswer: (buttonA.titleLabel?.text)!)
    }
    
    func button2() {
        buttonB.backgroundColor = .red
        variantPressed(buttonAnswer: (buttonB.titleLabel?.text)!)
    }
    
    func button3() {
        buttonC.backgroundColor = .red
        variantPressed(buttonAnswer: (buttonC.titleLabel?.text)!)
    }
    
    func button4() {
        buttonD.backgroundColor = .red
        variantPressed(buttonAnswer: (buttonD.titleLabel?.text)!)
    }
    
    func menuPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func rePlayGame() {
        list.removeAll()
        answers.removeAll()
        progress = 0.04
        seconds = 28
        i = 0
        score = 0
        
        startGame()
    }

    func variantPressed(buttonAnswer: String) {
        if buttonAnswer == realAnswer {
            print("Correct")
            seconds = 28
            progress = 0
            progressBar.setProgress(CGFloat(progress), animated: false)
            nextQuestion()
        } else {
            
            [buttonA, buttonB, buttonC, buttonD].forEach{
                if $0.titleLabel?.text == realAnswer { $0.backgroundColor = .green }
            }
            
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
        
        buttonA.isEnabled = false
        buttonB.isEnabled = false
        buttonC.isEnabled = false
        buttonD.isEnabled = false
        
        timer.invalidate()
        
        gameOverView.isHidden = false
        resultLabel.text = "Correct: \(score)"
    }
    
    func nextQuestion() {
        score += 1
        scoreLabel.text = String(score)
        
        [buttonA, buttonB, buttonC, buttonD].forEach{
            $0.backgroundColor = .buttonColor
        }
        
        
        //Reload Questions Here
        i += 1
        newQuestionSetup()
    }
    
    //MARK: Timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    //MARK: Update Timer
    func updateTimer() {
        progressBar.setProgress(CGFloat(progress), animated: true)
        if seconds <= 0 {
            timer.invalidate()
            gameOverEffect()
        } else {
            seconds -= 1
        }
        progress += 0.04
    }

}
