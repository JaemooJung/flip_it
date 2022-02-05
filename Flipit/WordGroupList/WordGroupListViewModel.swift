//
//  WordGroupListViewModel.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import Foundation
import RealmSwift

class WordGroupListViewModel: ObservableObject {
    
    private(set) var localRealm: Realm?
    @Published private(set) var wordGroups: [WordGroup] = []
    
    init() {
        openRealm()
        fetchWordGroup()
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
                    fetchWordGroup()
                }
            } catch {
                print("Error adding new WordGroup to Realm : \(error.localizedDescription)")
            }
        }
    }
    
    func deleteWordGroup(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let wordGroupToDelete = localRealm.objects(WordGroup.self).filter(NSPredicate(format: "_id == %@", id))
                guard !wordGroupToDelete.isEmpty else { return }
                try localRealm.write({
                    localRealm.delete(wordGroupToDelete)
                    fetchWordGroup()
                })
            } catch {
                print("Error Deleting WordGroup\(id) from Realm : \(error.localizedDescription)")
            }
            
        }
    }
    
    func fetchWordGroup() {
        if let localRealm = localRealm {
            let fetchedResult = localRealm.objects(WordGroup.self).sorted(byKeyPath: "timestamp", ascending: true)
            self.wordGroups = Array(fetchedResult)
        }
    }
}
