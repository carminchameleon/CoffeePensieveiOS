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
    func signUp(_ userData: SignUpForm, onError: @escaping (_ error: Error) -> Void) {
        
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { authResult, error in
            if let error = error {
                print("Sign In Error -",error.localizedDescription)
                onError(error)
                return
            }
            guard let authData = authResult else  { return }
            let uid = authData.user.uid
            let uploadData = UploadForm(uid: uid, email: userData.email, name: userData.name, cups: userData.cups, morningTime: userData.morningTime, nightTime: userData.nightTime, limitTime: userData.limitTime, reminder: userData.reminder)
            
                self.uploadUserProfile(userData: uploadData) { error in
                    onError(error)
                }
            }
        }
    
    
    
    // MARK: - user profile upload to DB ( 생성 하는 것 )
    func uploadUserProfile(userData: UploadForm,  onError: @escaping (_ error: Error) -> Void) {
        let uid = userData.uid
        let userData: [String: Any] = [
            Constant.FStore.emailField: userData.email,
            Constant.FStore.nameField:userData.name,
            Constant.FStore.cupsField: userData.cups,
            
            Constant.FStore.morningTimeField: userData.morningTime,
            Constant.FStore.nightTimeField: userData.nightTime,
            Constant.FStore.limitTimeField: userData.limitTime,
            Constant.FStore.reminderField: userData.reminder
        ]
        
        db.collection(Constant.FStore.userCollection).document(uid).setData(userData){ error in
            if let error = error {
                onError(error)
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
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            Common.removeUserDefaultsObject(forKey: .userId)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError.localizedDescription)
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
    
    func deleteAccount(onError: @escaping ((_ error: NetworkError)->Void)) {
        let firebaseAuth = Auth.auth()
        
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            onError(.uidError)
            return
        }
        
        let user = firebaseAuth.currentUser
        let userId = uid as! String
        
        db.collection(Constant.FStore.userCollection).document(userId).delete() { error in
            if let error = error {
                onError(.dataError)
            }
        }
    
        user?.delete() { error in
            if let error = error {
                onError(.databaseError)
            }
        }

        do {
          try firebaseAuth.signOut()
            Common.removeUserDefaultsObject(forKey: .userId)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }

        
    }
    
}
