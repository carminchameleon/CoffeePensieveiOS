//
//  NetworkingManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/29.
//

import Foundation
import Firebase

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
    
    // MARK: - user profile upload to DB
    func uploadUserProfile(uid: String, email: String, name: String, morningTime: String, nightTime: String, limitTime: String, cups: Int) {
        let userData: [String: Any] = [
            Constant.FStore.emailField: email,
            Constant.FStore.nameField:name,
            Constant.FStore.cupsField: cups,
            
            Constant.FStore.morningTimeField: morningTime,
            Constant.FStore.nightTimeField: nightTime,
            Constant.FStore.limitTimeField: limitTime,
            
            Constant.FStore.morningReminderField: true,
            Constant.FStore.nightReminderField: true,
            Constant.FStore.limitReminderField: true,
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
    
    enum NetworkError: Error {
        case uidError
        case databaseError
        case dataError
    }
    
    typealias ProfileCompletion = (Result<UserProfile, NetworkError>) -> Void
    // MARK: - get user profile
    func getUserProfile(completion: @escaping ProfileCompletion) {
        // 유저 uid
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            completion(.failure(.uidError))
            return
        }
        let userId = uid as! String
        let docRef = db.collection(Constant.FStore.userCollection).document(userId)
   
//        docRef.getDocument { document, error in
//            guard let document = document, document.exists else {
//                completion(.failure(.databaseError))
//                return
//            }
//            guard let data = document.data() else {
//                completion(.failure(.dataError))
//                return
//            }
            
            //
//            let email = data[Constant.FStore.emailField ] as? String
//            let name = data[Constant.FStore.nameField] as? String
//            let cups = data[Constant.FStore.cupsField] as? Int
//
//            var morningTime = data[Constant.FStore.morningTimeField] as? String
//            var nightTime = data[Constant.FStore.nightTimeField] as? String
//            var limitTime = data[Constant.FStore.limitTimeField] as? String
//
//            var morningReminder = data[Constant.FStore.morningReminderField] as? Bool
//            var nightReminder = data[Constant.FStore.nightReminderField] as? Bool
//            var limitReminder = data[Constant.FStore.limitReminderField] as? Bool
//
//
//            let user = UserProfile(name: name, cups: cups, email: email, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, morningReminder: morningReminder, nightReminder: nightReminder, limitReminder: limitReminder)
//            completion(.success(user))
        }
        

    
    
}
