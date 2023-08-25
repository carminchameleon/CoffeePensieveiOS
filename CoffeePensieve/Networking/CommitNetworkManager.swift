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
    var todayCommitCount = 0
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
    
    // MARK: - Today's Commit Count
    func fetchTodayCommitCounts() async -> Result<Int, NetworkError> {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            return .failure(.uidError)
        }
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.commitCollection)
        
        let calendar = Calendar.current
        let now = Date()
        let midnightToday = calendar.startOfDay(for: now)
        
        let query = docRef.whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: midnightToday))
        let countQuery = query.count
        
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            let count = Int(truncating: snapshot.count)
            todayCommitCount = count
            return .success(count)
        } catch {
            return .failure(.databaseError)
        }
    }
    
    // MARK: - Total Commit Counts
    func fetchTotalCommitCounts() async -> Result<Int, NetworkError> {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            return .failure(.uidError)
        }
        
        let userId = uid as! String
        let query = db.collection(Constant.FStore.commitCollection).whereField("uid", isEqualTo: userId)
        let countQuery = query.count
        
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            let count = Int(truncating: snapshot.count)
            return .success(count)
        } catch {
            return .failure(.databaseError)
        }
    }
    
    // MARK: - 음료 등록
    typealias uploadTodayDrinkCompletion = (Result<Date,NetworkError>) -> Void
    func uploadTodayDrink(drinkId: Int, moodId: Int, tagIds: [Int], memo: String, completion: @escaping uploadTodayDrinkCompletion ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.uidError))
            return
        }
        
        let currentTime = Date()
        let commitData: [String: Any] = [
            Constant.FStore.uidField: uid,
            Constant.FStore.createdAtField: currentTime,
            Constant.FStore.drinkField : drinkId,
            Constant.FStore.moodField : moodId,
            Constant.FStore.tagListField : tagIds,
            Constant.FStore.memoField : memo,
        ]
        // 성공하면 시간 보낼 것
        uploadCommit(data: commitData) { result in
            switch result {
            case .success:
                completion(.success(currentTime))
            case .failure:
                completion(.failure(.databaseError))
            }
        }
    }

}
