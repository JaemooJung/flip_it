//
//  WordGroupListViewModel.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import Foundation
import RealmSwift
import SwiftUI

class WordGroupListViewModel: ObservableObject {
    
    private(set) var localRealm: Realm?
    @Published private(set) var wordGroups: [WordGroup] = []
    
    init() {
        openRealm()
    }
    
    var memorizedWordCount: Int {
        return localRealm?.objects(Word.self).where({$0.isMemorized == true}).count ?? 0
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
    
    func addWordGroup(groupName: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(WordGroup(groupName: groupName))
                }
            } catch {
                print("Error adding new WordGroup to Realm : \(error.localizedDescription)")
            }
        }
    }
    
    func deleteWordGroup(id: ObjectId) {
        print("delete started")
        if let localRealm = localRealm {
            do {
                let wordGroupToDelete = localRealm.objects(WordGroup.self).filter(NSPredicate(format: "_id == %@", id))
                guard !wordGroupToDelete.isEmpty else { return }
                try localRealm.write({
                    if let words = wordGroupToDelete.first?.words {
                        for word in words {
                            if word.isMemorized == false {
                                localRealm.delete(word)
                            }
                        }
                    }
                    localRealm.delete(wordGroupToDelete)
                })
                UserDefaults.standard.set(nil, forKey: keyForWordGroupID)
            } catch {
                print("Error Deleting WordGroup\(id) from Realm : \(error.localizedDescription)")
            }
        }
        print("Delete done")
    }
    
    func updateWordGroup(id: ObjectId, newWordGroupName: String) {
        if let localRealm = localRealm {
            let wordGroupToUpdate = localRealm.objects(WordGroup.self).filter(NSPredicate(format: "_id == %@", id))
            guard !wordGroupToUpdate.isEmpty else { return }
            wordGroupToUpdate.first!.updateGroupName(newName: newWordGroupName)
        }
    }
    
    func fetchWordGroup() {
        if let localRealm = localRealm {
            let fetchedResult = localRealm.objects(WordGroup.self).sorted(byKeyPath: "timestamp", ascending: false)
            self.wordGroups = Array(fetchedResult)
        }
    }
    
}
