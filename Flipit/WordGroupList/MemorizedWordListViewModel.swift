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
        fetchMemorizedWords()
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

    func fetchMemorizedWords() {
        if let localRealm = localRealm {
            let fetchedResult = localRealm.objects(Word.self).where({$0.isMemorized == true}).sorted(byKeyPath: "timestamp", ascending: true)
            self.MemorizedWords = Array(fetchedResult)
        }
    }
    
    func markWordAsNotMemorized(wordId: ObjectId) {
        if let localRealm = localRealm {
            do {
                let wordToUpdate = localRealm.objects(Word.self).filter(NSPredicate(format: "_id == %@", wordId))
                guard (!wordToUpdate.isEmpty) else { return }
                try localRealm.write {
                    wordToUpdate[0].isMemorized = false
                    fetchMemorizedWords()
                }
            } catch {
                print("Error changing isMemorized : \(error.localizedDescription)")
            }
        }
    }
}
