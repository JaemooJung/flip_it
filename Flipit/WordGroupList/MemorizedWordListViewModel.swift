//
//  MemorizedWordListViewModel.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/07.
//

import Foundation
import RealmSwift

class MemorizedWordListViewModel: ObservableObject {
    
    private(set) var localRealm: Realm?
    @Published private(set) var MemorizedWords: [Word] = []
    
    init() {
        openRealm()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm : \(error.localizedDescription)")
        }
    }

//    func fetchMemorizedWords() {
//        if let localRealm = localRealm {
//            let fetchedResult = localRealm.objects(Word.self).where({$0.isMemorized == true}).sorted(byKeyPath: "timestamp", ascending: true)
//            self.MemorizedWords = Array(fetchedResult)
//        }
//    }
    
    func markWordAsNotMemorized(wordId: ObjectId) {
        if let localRealm = localRealm {
            do {
                guard let wordToUpdate = localRealm.object(ofType: Word.self, forPrimaryKey: wordId) else {
                    print("failed to find word to update from realm")
                    return
                }
                if (wordToUpdate.wordGroup.isEmpty) {
                    try localRealm.write {
                        localRealm.delete(wordToUpdate)
                    }
                } else {
                    try localRealm.write {
                        wordToUpdate.isMemorized = false
                    }
                }
            } catch {
                print("Error changing isMemorized : \(error.localizedDescription)")
            }
        }
    }
    
    func deleteWord(wordId: ObjectId) {
        if let localRealm = localRealm {
            do {
                guard let wordToDelete = localRealm.object(ofType: Word.self, forPrimaryKey: wordId) else {
                    print("failed to find word to delete from realm")
                    return
                }
                try localRealm.write {
                    localRealm.delete(wordToDelete)
                }
            } catch {
                print("Error: failed to delete word \(error.localizedDescription)")
            }
        }
    }
    
    
}
