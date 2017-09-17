//
//  HighScore.swift
//  movie_quotes
//
//  Created by Apple on 16.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import Foundation
import RealmSwift

class HighScore: Object {

    dynamic var HighScoreID = UUID().uuidString
    dynamic var score = 0
    
    override static func primaryKey() -> String? {
        return "HighScoreID"
    }
    
}

class Score {
    
    static func highScoreGetter(completion: @escaping (Int?) -> Void) {
        let realm = try! Realm()
        let data = realm.objects(HighScore.self)
        
        guard let result = data.first?.score else {
            completion(nil)
            return
        }
        
        completion(result)
    }
    
    static func highScoreSetter(score: Int) {
        let realm = try! Realm()
        
        let object = HighScore()
        object.HighScoreID = "HighScoreID"
        object.score = score
        
        try! realm.write {
            realm.add(object, update: true)
        }
    }

}
