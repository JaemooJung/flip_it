//
//  WordModel.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import Foundation
import RealmSwift

class Word: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var wordString: String = "NoWordString"
    @Persisted var meaningString: String = "NoMeaningString"
    @Persisted var timestamp: Date = Date()
    @Persisted var isMemorized: Bool = false
    
    @Persisted(originProperty: "words") var wordGroup: LinkingObjects<WordGroup>
    
    convenience init(word: String, meaning: String) {
        self.init()
        self.wordString = word
        self.meaningString = meaning
    }
}
