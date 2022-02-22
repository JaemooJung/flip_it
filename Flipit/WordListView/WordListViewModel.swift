//
//  WordListViewModel.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import Foundation
import RealmSwift

class WordListViewModel: ObservableObject {
    
    private(set) var localRealm: Realm?
    
    @Published private(set) var words: [Word] = []
    let wordGroupId: String
    
    var fetchedWordGroup: WordGroup?
    
    init(wordGroupId: String) {
        self.wordGroupId = wordGroupId
        openRealm()
        fetchWords()
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
    
    func addNewWord(newWord: String, meaning: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let wordToaAdd = Word()
                    wordToaAdd.wordString = newWord
                    if (meaning.isEmpty) {
                        wordToaAdd.meaningString = "     "
                    } else {
                        wordToaAdd.meaningString = meaning
                    }
                    localRealm.add(wordToaAdd)
                    self.fetchedWordGroup?.words.append(wordToaAdd)
                    fetchWords()
                }
            } catch {
                print("Error adding new Word to Realm : \(error.localizedDescription)")
            }
        }
    }
    
    func markWordAsMemorized(wordId: ObjectId) {
        if let localRealm = localRealm {
            do {
                let wordToUpdate = localRealm.objects(Word.self).filter(NSPredicate(format: "_id == %@", wordId))
                guard (!wordToUpdate.isEmpty) else { return }
                try localRealm.write {
                    wordToUpdate[0].isMemorized = true
                    fetchWords()
                }
            } catch {
                print("Error changing isMemorized : \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWords() {
        guard let localRealm = localRealm else { return }
        let convertedID = try! ObjectId(string: self.wordGroupId)
        guard let fetchedResult = localRealm.objects(WordGroup.self)
                .filter(NSPredicate(format: "_id == %@", convertedID)).first else { return }
        self.fetchedWordGroup = fetchedResult
        let wordsToFetch = fetchedWordGroup!.words.where({$0.isMemorized == false}).sorted(byKeyPath: "timestamp", ascending: false)
        self.words = Array(wordsToFetch)
    }
}
