//
//  CommitNetworkManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/06.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class CommitNetworkManager {
    
    static let shared = CommitNetworkManager()
    private init() {}
    
    let db = Firestore.firestore()
    
    typealias DrinkCompletion = (Result<[Drink],NetworkError>) -> Void
    typealias MoodCompletion = (Result<[Mood],NetworkError>) -> Void
    typealias TagCompletion = (Result<[Tag],NetworkError>) -> Void
    typealias CommitCompletion = (Result<Void,NetworkError>) -> Void
    typealias DeleteCompletion = (Result<Void,NetworkError>) -> Void

    // MARK: - get coffee list
    func fetchDrinks(completion: @escaping DrinkCompletion) {
        let docRef = db.collection(Constant.FStore.drinkCollection)
        docRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(.databaseError))
            } else {
                var drinks:[Drink] = []
                for document in querySnapshot!.documents {
                    do {
                        let drink = try document.data(as: Drink.self)
                        drinks.append(drink)
                    } catch {
                        completion(.failure(.dataError))
                    }
                }
                completion(.success(drinks))
            }
        }
    }
    
    // MARK: - get mood list
    func fetchMoods(completion: @escaping MoodCompletion) {
        let docRef = db.collection(Constant.FStore.moodCollection)
        docRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(.databaseError))
            } else {
                var moods:[Mood] = []
                for document in querySnapshot!.documents {
                    do {
                        let mood = try document.data(as: Mood.self)
                        moods.append(mood)
                    } catch {
                        completion(.failure(.dataError))
                    }
                }
                completion(.success(moods))
            }
        }
    }
    
    // MARK: - get tag list
    func fetchTags(completion: @escaping TagCompletion) {
        let docRef = db.collection(Constant.FStore.tagCollection)
        docRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(.databaseError))
            } else {
                var tags:[Tag] = []
                for document in querySnapshot!.documents {
                    do {
                        let tag = try document.data(as: Tag.self)
                        tags.append(tag)
                    } catch {
                        completion(.failure(.dataError))
                    }
                }
                completion(.success(tags))
            }
        }
    }
    
    // MARK: - upload coffee commit to DB
    func uploadCommit(data:[String: Any], completion: @escaping CommitCompletion) {
        db.collection(Constant.FStore.commitCollection).addDocument(data: data) { error in
            if let error = error {
                print("Upload Commit Error -", error.localizedDescription)
                completion(.failure(.databaseError))
            }
        }
        completion(.success(()))
    }
    
    
    func deleteCommit(id: String, completion: @escaping DeleteCompletion ) {
        db.collection(Constant.FStore.commitCollection).document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(.failure(.dataError))
            } else {
                completion(.success(()))
                print("Document successfully removed!")
            }
        }
    }
}
    
