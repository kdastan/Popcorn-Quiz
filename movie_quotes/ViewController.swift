//
//  ViewController.swift
//  movie_quotes
//
//  Created by Apple on 14.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ViewController: UIViewController {
    
    var model: [Model] = []
    var i = 0
    var score = 0
    
    var answers: [String] = []
    var realAnswer = ""
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func button1(_ sender: UIButton) {
        variantPressed(buttonAnswer: (buttonA.titleLabel?.text)!)
    }
    
    @IBAction func button2(_ sender: UIButton) {
        variantPressed(buttonAnswer: (buttonB.titleLabel?.text)!)
    }
    
    @IBAction func button3(_ sender: UIButton) {
        variantPressed(buttonAnswer: (buttonC.titleLabel?.text)!)
    }
    
    @IBAction func button4(_ sender: UIButton) {
        variantPressed(buttonAnswer: (buttonD.titleLabel?.text)!)
    }

    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var blurImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonSetup()
        SVProgressHUD.show()
        fetch { (success) in
            self.questionSetup()
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
        
        questionLabel.text = model[i].quote
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
    
    
    func variantPressed(buttonAnswer: String) {
        if buttonAnswer == realAnswer {
            print("Correct")
            nextQuestion()
        } else {
            gameOverEffect()
            print("Not correct")
        }
    }
    
    func buttonSetup() {
        buttonA.layer.cornerRadius = 4
        buttonA.backgroundColor = .buttonColor
        buttonB.layer.cornerRadius = 4
        buttonB.backgroundColor = .buttonColor
        buttonC.layer.cornerRadius = 4
        buttonC.backgroundColor = .buttonColor
        buttonD.layer.cornerRadius = 4
        buttonD.backgroundColor = .buttonColor
    }
    
}
















