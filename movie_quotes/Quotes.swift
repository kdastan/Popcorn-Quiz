//
//  Quotes.swift
//  movie_quotes
//
//  Created by Apple on 08.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct QuotesList {
    var name: String!
    var quote: String!
}

class Quotes {

    static func fetchQuotes(completion: @escaping ([[String: String]]?) -> Void) {
        let ref = Database.database().reference().child("Quotes")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var list: [[String: String]] = [[:]]
            
            guard let _ = snapshot.value else {
                completion(nil)
                return
            }
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let value = rest.value as! [String: String]
                list.insert(value, at: 0)
            }
            completion(list)
        })
    }
    
    static func userExistsQuery(curID: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(curID) {
                print("User doesn't exists")
                completion(false)
            } else {
                completion(true)
                print("User exists")
            }
            
        })
    }
    
    
}
