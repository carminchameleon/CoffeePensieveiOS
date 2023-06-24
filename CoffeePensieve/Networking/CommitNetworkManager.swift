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
    
    typealias CommitCompletion = (Result<Void,NetworkError>) -> Void
    typealias DeleteCompletion = (Result<Void,NetworkError>) -> Void


    // MARK: - upload coffee commit to DB
    func uploadCommit(data:[String: Any], completion: @escaping CommitCompletion) {
        db.collection(Constant.FStore.commitCollection).addDocument(data: data) { error in
            if let _ = error {
                completion(.failure(.databaseError))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func deleteCommit(id: String, completion: @escaping DeleteCompletion ) {
        db.collection(Constant.FStore.commitCollection).document(id).delete() { err in
            if let _ = err {
                completion(.failure(.dataError))
            } else {
                completion(.success(()))
            }
        }
    }
}
    
