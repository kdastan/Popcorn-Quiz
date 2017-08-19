//
//  ViewController.swift
//  movie_quotes
//
//  Created by Apple on 14.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    var model: [Model] = []
    
    @IBAction func button(_ sender: UIButton) {
        fetch()
    }

    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetch() {
        
        let url = "https://andruxnet-random-famous-quotes.p.mashape.com/?cat=movies&count=9"
        
        let headers = [
            "X-Mashape-Key": "9UO47e8LvRmshhVE8LGgNL8ew6AWp1f4ImGjsn19NTPqzDbIZ0",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            guard let json = response.result.value as? [Any] else {return}
            for i in 0..<json.count{
                let item = json[i] as? [String: String]
                let author = item?["author"] as? String
                let quote = item?["quote"] as? String
                let object = Model(author: author!, quote: quote!)
                self.model.append(object)
                print("\(self.model[i].author!) \(self.model[i].quote!)")
                
            }
        }
       self.model.removeAll()
      }
    
}
















