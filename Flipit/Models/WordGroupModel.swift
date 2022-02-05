//
//  WordGroupModel.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import Foundation
import RealmSwift

class WordGroup: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var groupName: String = "NoGroupName"
    @Persisted var wordLanguage: String = "NoWordLang"
    @Persisted var meaningLanguage: String = "NoMeaningLang"
    @Persisted var timestamp: Date = Date()
    
    @Persisted var words: List<Word>
    
    convenience init(groupName: String) {
        self.init()
        self.groupName = groupName
    }
}
