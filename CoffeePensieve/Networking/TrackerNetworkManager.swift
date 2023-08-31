//
//  TrackerNetworkManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/13.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class TrackerNetworkManager {
    
    static let shared = TrackerNetworkManager()
    private init() {}

    let db = Firestore.firestore()
    typealias CommitCompletion = (Result<[Commit], NetworkError>) -> Void
    
    // change format of DB DATA to commit model ( timestamp )
    func formatCommitData(document: QueryDocumentSnapshot) -> Commit? {
        let id = document.documentID
        guard let timestamp = document.data()["createdAt"] as? Timestamp else { return nil }
        let createdAt = timestamp.dateValue()
        let uid = document.data()["uid"] as! String
        let drinkId = document.data()["drinkId"] as! Int
        let tagIds = document.data()["tagIds"] as! [Int]
        let moodId = document.data()["moodId"] as! Int
        let memo = document.data()["memo"] as! String
        
        let data = Commit(id: id, uid: uid, drinkId: drinkId, moodId: moodId, tagIds: tagIds, memo: memo, createdAt: createdAt)
        return data
    }


    func fetchTodayDrinksFromDB() async throws -> [Commit] {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            throw NetworkError.uidError
        }

        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.commitCollection)
        let calendar = Calendar.current
        let now = Date()
        let midnightToday = calendar.startOfDay(for: now)

        do {
            let querySnapshot = try await docRef.whereField("uid", isEqualTo: userId)
                .whereField("createdAt", isGreaterThan: Timestamp(date: midnightToday))
                .getDocuments()
            
            var commits: [Commit] = []
            
            for document in querySnapshot.documents {
                if let commit = formatCommitData(document: document) {
                    commits.append(commit)
                }
            }
            return commits
        } catch {
            throw NetworkError.databaseError
        }
    }
    
    
    // MARK: - fetch All commits
    func fetchAllCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.commitCollection)
        
        docRef
            .whereField("uid", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let _ = error {
                    completion(.failure(.databaseError))
                } else {
                    var commits: [Commit] = []
                    for document in querySnapshot!.documents {
                        guard let commit = self.formatCommitData(document: document) else { return }
                        commits.append(commit)
                    }
                    completion(.success(commits))
                }
            }
    }

    
    typealias RecordResult = (data: [Commit], snapshot: DocumentSnapshot?)
    func fetchAllCommitsWithOffset(size: Int, lastDocument: DocumentSnapshot?) async throws -> RecordResult {
        do {
            guard let uid = Common.getUserDefaultsObject(forKey: .userId) else { throw NetworkError.uidError }
            let userId = uid as! String
            
            let query = getQueryWithLastSnapShot(userId: userId, size: size, lastDocument: lastDocument)
            
            let querySnapshot = try await query.getDocuments()
            var commits: [Commit] = []
            
            querySnapshot.documents.forEach { document in
                if let commit = formatCommitData(document: document) {
                    commits.append(commit)
                }
            }
            return (commits, querySnapshot.documents.last)
            
        } catch {
            throw NetworkError.databaseError
        }
    }
    
    func getQueryWithLastSnapShot(userId: String, size: Int, lastDocument: DocumentSnapshot?) -> Query {
        let docRef = db.collection(Constant.FStore.commitCollection)
        if let lastDoc = lastDocument {
            return docRef.whereField("uid", isEqualTo: userId)
                                        .order(by: "createdAt", descending: true)
                                        .start(afterDocument: lastDoc)
                                        .limit(to: size)
        } else {
           return docRef.whereField("uid", isEqualTo: userId)
                                        .order(by: "createdAt", descending: true)
                                        .limit(to: size)

        }
    }
    
    
    // MARK: - Commit Count 가져오기
    // 지금까지 전체 Commit 횟수 가져오기
    func fetchNumberOfAllCommits() async throws -> Int {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            throw NetworkError.uidError
        }
        
        let userId = uid as! String
        let query = db.collection(Constant.FStore.commitCollection).whereField("uid", isEqualTo: userId)
        let countQuery = query.count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            let count = Int(truncating: snapshot.count)
            return count
        } catch {
            throw NetworkError.databaseError
        }
    }
    
    // MARK: - fetch Number of weekly Commits
    func fetchNumberOfWeeklyCommits() async throws -> Int {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            throw NetworkError.uidError
        }
        let userId = uid as! String
        let today = Date()
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let query = db.collection(Constant.FStore.commitCollection)
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: startOfWeek))
        
        let countQuery = query.count
            do {
                let snapshot = try await countQuery.getAggregation(source: .server)
                let count = Int(truncating: snapshot.count)
                return count
            } catch {
                throw NetworkError.databaseError
            }
    }

    // MARK: - fetch Number of Monthly Commits
    func fetchNumberOfMonthlyCommits() async throws -> Int {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            throw NetworkError.uidError
        }
        let userId = uid as! String
        let today = Date()
        let calendar = Calendar.current
    
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let query = db.collection(Constant.FStore.commitCollection)
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: startOfMonth))
        let countQuery = query.count

            do {
                let snapshot = try await countQuery.getAggregation(source: .server)
                let count = Int(truncating: snapshot.count)
                return count
            } catch {
                throw NetworkError.databaseError
            }
        }
    
    // MARK: - fetch Number of Yearly Commits
    func fetchNumberOfYearlyCommits() async throws -> Int {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            throw NetworkError.uidError
        }
        let userId = uid as! String
        let today = Date()
        let calendar = Calendar.current
    
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today))! //
        let query = db.collection(Constant.FStore.commitCollection)
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: startOfYear))
        let countQuery = query.count
            do {
                let snapshot = try await countQuery.getAggregation(source: .server)
                let count = Int(truncating: snapshot.count)
                return count
            } catch {
                throw NetworkError.databaseError
            }
    }

    // MARK: - fetch specific duration's commits
    func fetchDurationCommit(start: Date, finish: Date, completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            completion(.failure(.uidError))
            return
        }

        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.commitCollection)
        docRef
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: start))
            .whereField("createdAt", isLessThan: Timestamp(date: finish))
            .getDocuments { (querySnapshot, error) in
                if let _ = error {
                    completion(.failure(.databaseError))
                } else {
                    var commits: [Commit] = []
                    for document in querySnapshot!.documents {
                        guard let commit = self.formatCommitData(document: document) else { return }
                        commits.append(commit)
                    }
                    completion(.success(commits))
                }
            }
    }
    
    // MARK: - 특정 기간의 commit list 조회
    func fetchDurationCommitList(start: Date, finish: Date) async throws -> [Commit] {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            throw NetworkError.uidError
        }
        
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.commitCollection)
        
        do {
            let querySnapshot = try await docRef
                .whereField("uid", isEqualTo: userId)
                .whereField("createdAt", isGreaterThan: Timestamp(date: start))
                .whereField("createdAt", isLessThan: Timestamp(date: finish))
                .getDocuments()
            
            var commits: [Commit] = []
            querySnapshot.documents.forEach { document in
                if let commit = self.formatCommitData(document: document) {
                    commits.append(commit)
                }
            }
            return commits
        } catch {
            throw NetworkError.databaseError
        }
    }
    
    
    // MARK: - NOT USING NOW
    // MARK: - fetch Weekly commits
    func fetchWeeklyCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let today = Date() // 현재 날짜
        // 이번 주의 시작 날짜 계산
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))! // 이번 주 일요일 날짜
        let docRef = db.collection(Constant.FStore.commitCollection)
        docRef
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: startOfWeek))
            .getDocuments { (querySnapshot, error) in
                if let _ = error {
                    completion(.failure(.databaseError))
                } else {
                    var commits: [Commit] = []
                    for document in querySnapshot!.documents {
                        guard let commit = self.formatCommitData(document: document) else { return }
                        commits.append(commit)
                    }
                    completion(.success(commits))
                }
            }
    }
    
    // MARK: - fetch Monthly commits
    func fetchMonthlyCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        
        let today = Date()
        let calendar = Calendar.current
        // 이번 달의 시작 날짜 계산
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))! // startOfMonth는 이번 달 1일의 날짜가 됩니다.
        let docRef = db.collection(Constant.FStore.commitCollection)
        docRef
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: startOfMonth))
            .getDocuments { (querySnapshot, error) in
                if let _ = error {
                    completion(.failure(.databaseError))
                } else {
                    var commits: [Commit] = []
                    for document in querySnapshot!.documents {
                        guard let commit = self.formatCommitData(document: document) else { return }
                        commits.append(commit)
                    }
                    completion(.success(commits))
                }
            }
    }
    
    
    // MARK: - fetch yearly commits
    func fetchYearlyCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String

        let today = Date()
        let calendar = Calendar.current
        // 이번 달의 시작 날짜 계산
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today))! // 이번 년도
        let docRef = db.collection(Constant.FStore.commitCollection)
        docRef
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: startOfYear))
            .getDocuments { (querySnapshot, error) in
                if let _ = error {
                    completion(.failure(.databaseError))
                } else {
                    var commits: [Commit] = []
                    for document in querySnapshot!.documents {
                        guard let commit = self.formatCommitData(document: document) else { return }
                        commits.append(commit)
                    }
                    completion(.success(commits))
                }
            }
    }
    
    
}
