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

    
    func fetchTodayCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.commitCollection)
        
        let calendar = Calendar.current
        let now = Date()
        let midnightToday = calendar.startOfDay(for: now)
        docRef
            .whereField("uid", isEqualTo: userId)
            .whereField("createdAt", isGreaterThan: Timestamp(date: midnightToday))
            .getDocuments { (querySnapshot, error) in
                if let _ = error {
                    completion(.failure(.databaseError))
                } else {
                    var commits: [Commit] = []
                    for document in querySnapshot!.documents {
                        let id = document.documentID
                        guard let timestamp = document.data()["createdAt"] as? Timestamp else { return }
                        let createdAt = timestamp.dateValue()
                        let uid = document.data()["uid"] as! String
                        let drinkId = document.data()["drinkId"] as! Int
                        let tagIds = document.data()["tagIds"] as! [Int]
                        let moodId = document.data()["moodId"] as! Int
                        let memo = document.data()["memo"] as! String
                        let data = Commit(id: id, uid: uid, drinkId: drinkId, moodId: moodId, tagIds: tagIds, memo: memo, createdAt: createdAt)
                        commits.append(data)
                    }
                    completion(.success(commits))
                }
            }
    }
    
    // MARK: - 모든 커밋
    func fetchAllCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
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
    
    
    // MARK: - 이번주 커밋
    func fetchWeeklyCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
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
    
    
    func fetchMonthlyCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
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
    

    func fetchYearlyCommits(completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
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
    
    // MARK: - 위클리 커밋 수
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
                print("Can't load users commit count",error.localizedDescription);
                throw NetworkError.databaseError
            }
        }

    // MARK: - 먼슬리 커밋 수
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
                print("Can't load users commit count",error.localizedDescription);
                throw NetworkError.databaseError
            }
        }
    // MARK: - 이얼리 커밋 수
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
                print("Can't load users commit count",error.localizedDescription);
                throw NetworkError.databaseError
            }
        }

    func fetchDurationCommit(start: Date, finish: Date, completion: @escaping CommitCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String

//        let today = Date()
//        let calendar = Calendar.current
//        // 이번 달의 시작 날짜 계산
//        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today))! // 이번 년도
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
    
    

    
}
