//
//  NetworkingManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/29.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
    case uidError
    case databaseError
    case dataError
}

final class AuthNetworkManager {
    
    static let shared = AuthNetworkManager()
    private init() {}
    
    let db = Firestore.firestore()
    
    // MARK: - create new user
    func signUp(email: String, password: String, name: String, morningTime: String,nightTime: String, limitTime: String, cups: Int, onError: @escaping (_ error: Error) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Sign In Error -",error.localizedDescription)
                onError(error)
                return
            }
            guard let authData = authResult else  { return }
            let uid = authData.user.uid
            self.uploadUserProfile(uid: uid, email: email, name: name, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, cups: cups)
        }
    }
    
    // MARK: - user profile upload to DB ( 생성 하는 것 )
    func uploadUserProfile(uid: String, email: String, name: String, morningTime: String, nightTime: String, limitTime: String, cups: Int) {
        let userData: [String: Any] = [
            Constant.FStore.emailField: email,
            Constant.FStore.nameField:name,
            Constant.FStore.cupsField: cups,
            
            Constant.FStore.morningTimeField: morningTime,
            Constant.FStore.nightTimeField: nightTime,
            Constant.FStore.limitTimeField: limitTime,
            
            Constant.FStore.reminderField: true
        ]
        
        db.collection(Constant.FStore.userCollection).document(uid).setData(userData){ error in
            if let error = error {
                print("Upload Profile Error -", error.localizedDescription)
            }
        }
    }
    
    // MARK: - sign iin
    func signIn(email: String, password: String, onError: @escaping (_ error: Error) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                onError(error)
            }
        }
    }
    // MARK: - forgot password
    typealias ForgotPasswordCompletion = (Result<String, Error>) -> Void
    func forgotPassword(email: String, completion: @escaping ForgotPasswordCompletion) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success("Okay"))
        }
    }
    
    
    typealias ProfileCompletion = (Result<UserProfile, NetworkError>) -> Void
    // MARK: - get user profile
    func getUserProfile(completion: @escaping ProfileCompletion) {
        // 유저 uid
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.userCollection).document(userId)
        docRef.getDocument(as: UserProfile.self) { result in
            switch result {
            case .success(let userProfile):
                completion(.success(userProfile))
            case .failure(let error):
                print("Erorr to get user profile -", error.localizedDescription)
                completion(.failure(.dataError))
            }
        }
    }
    

    // MARK: - update user preference
    // update 성공 -> 유저 데이터 업데이트 해줘야 함 - 다른 곳에서 사용하기 때문에
    func updateUserPreference(data: UserPreference, completion: @escaping ProfileCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.userCollection).document(userId)
        docRef.updateData([
            Constant.FStore.cupsField: data.cups,
            Constant.FStore.morningTimeField: data.morningTime,
            Constant.FStore.nightTimeField: data.nightTime,
            Constant.FStore.limitTimeField: data.limitTime,
            Constant.FStore.reminderField: data.reminder
        ]) { err in
            if let err = err {
                completion(.failure(.databaseError))
                print("Error updating document: \(err)")
            } else {
                docRef.getDocument(as: UserProfile.self) { result in
                    switch result {
                    case .success(let userProfile):
                        completion(.success(userProfile))
                    case .failure:
                        break
                    }
                }
            }
            
        }
    }

    
    // MARK: - update user preference
    // update 성공 -> 유저 데이터 업데이트 해줘야 함 - 다른 곳에서 사용하기 때문에
    func updateUserProfile(name: String, completion: @escaping ProfileCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.userCollection).document(userId)
        docRef.updateData([
            Constant.FStore.nameField: name,
        ]) { err in
            if let err = err {
                completion(.failure(.databaseError))
                print("Error updating document: \(err)")
            } else {
                self.getUserProfileFromRef(docRef: docRef) { userProfile in
                    completion(.success(userProfile))
                }
//                docRef.getDocument(as: UserProfile.self) { result in
//                    switch result {
//                    case .success(let userProfile):
//                        completion(.success(userProfile))
//                    case .failure:
//                        break
//                    }
//                }
            }
            
        }
    }
    
    func getUserProfileFromRef(docRef: DocumentReference, onSuccess: @escaping ((UserProfile) -> Void)) {
        docRef.getDocument(as: UserProfile.self) { result in
            switch result {
            case .success(let userProfile):
                onSuccess(userProfile)
            case .failure:
                break
            }
        }
    }
    
    typealias CommitNumberCompletion = (Result<Int, NetworkError>) -> Void
    func getNumberOfCommits(completion: @escaping CommitNumberCompletion) {
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            print("There's no uid, so can't bring user id from userDefualts")
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let query = db.collection(Constant.FStore.commitCollection).whereField("uid", isEqualTo: userId)
        let countQuery = query.count
        
        Task {
            do {
                let snapshot = try await countQuery.getAggregation(source: .server)
                let count = Int(truncating: snapshot.count)
                completion(.success(count))
            } catch {
                completion(.failure(.databaseError))
                print("Can't load users commit count",error.localizedDescription);
            }
        }
    }
    
    

}
