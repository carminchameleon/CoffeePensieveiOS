//
//  AuthNetworkManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/29.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
    case uidError // uid 없을 때
    case databaseError
    case dataError
}

final class AuthNetworkManager {
    
    static let shared = AuthNetworkManager()
    private init() {}
    
    let db = Firestore.firestore()
    
    // MARK: - 새로운 유저 생성
    func signUp(_ userData: SignUpForm, onError: @escaping (_ error: Error) -> Void) {
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { authResult, error in
            if let error = error {
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
    
    // MARK: - 유저 콜렉션 DB에 유저 프로필 생성
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
            }
        }
    }
    
    // MARK: - 이메일 로그인
    func signIn(email: String, password: String, onError: @escaping (_ error: Error) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                onError(error)
            }
        }
    }
    
    // MARK: - 로그아웃
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            Common.removeAllUserDefaultObject()
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
        
    // MARK: - REFCTORING - 수정된 유저 프로필 DB에 업데이트하기
    func updatePreference(data: UserPreference) async throws -> Void {
        do {
            guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
                throw NetworkError.uidError
            }
            let userId = uid as! String
            let docRef = db.collection(Constant.FStore.userCollection).document(userId)
            let data: [String : Any] = [
                Constant.FStore.cupsField: data.cups,
                Constant.FStore.morningTimeField: data.morningTime,
                Constant.FStore.nightTimeField: data.nightTime,
                Constant.FStore.limitTimeField: data.limitTime,
                Constant.FStore.reminderField: data.reminder]
            try await docRef.updateData(data)
        } catch {
            throw NetworkError.databaseError
        }
    }
    
    func getUpdatedUserData() async throws -> UserProfile {
        do {
            guard let userId = Auth.auth().currentUser?.uid else { throw NetworkError.uidError }
            let docRef = db.collection(Constant.FStore.userCollection).document(userId)
            let userData = try await docRef.getDocument(as: UserProfile.self)
            return userData
        } catch {
            throw NetworkError.databaseError
        }
    }
    
    // MARK: - 유저 이름 업데이트
    func updateUserName(name: String) async throws -> Void {
        do {
            guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
                throw NetworkError.uidError
            }
            let userId = uid as! String
            let docRef = db.collection(Constant.FStore.userCollection).document(userId)
            let data: [String : Any] = [Constant.FStore.nameField: name]
            try await docRef.updateData(data)
        } catch {
            throw NetworkError.databaseError
        }
    }
    
    // MARK: ============== 유저 데이터 가져오고 저장하는 부분 ===============
    // MARK: - api에서 받은 데이터를 userDefault에 저장한다. (사용중)
    func saveProfiletoUserDefaults(userProfile: UserProfile) {
        Common.setUserDefaults(userProfile.name, forKey: .name)
        Common.setUserDefaults(userProfile.email, forKey: .email)
        Common.setUserDefaults(userProfile.cups, forKey: .cups)
        Common.setUserDefaults(userProfile.morningTime, forKey: .morningTime)
        Common.setUserDefaults(userProfile.nightTime, forKey: .nightTime)
        Common.setUserDefaults(userProfile.limitTime, forKey: .limitTime)
        Common.setUserDefaults(userProfile.reminder, forKey: .reminder)
    }
    
    func getProfileFromUserDefault() -> UserProfile? {
        guard let name = Common.getUserDefaultsObject(forKey: .name) as? String else { return nil }
        guard let email = Common.getUserDefaultsObject(forKey: .email) as? String else { return nil }
        guard let cups = Common.getUserDefaultsObject(forKey: .cups) as? Int else { return nil }
        guard let nightTime = Common.getUserDefaultsObject(forKey: .nightTime) as? String else { return nil }
        guard let morningTime = Common.getUserDefaultsObject(forKey: .morningTime) as? String else { return nil }
        guard let limitTime = Common.getUserDefaultsObject(forKey: .limitTime) as? String else { return nil }
        guard let reminder = Common.getUserDefaultsObject(forKey: .reminder) as? Bool else { return nil }
        
       // 어떤 값도 optional이 아니라면?
        let profile = UserProfile(name: name, cups: cups, email: email, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, reminder: reminder)
        return profile
    }
    
    
    // MARK: - 계정 삭제
    func deleteAccount(onError: @escaping ((_ error: NetworkError)->Void)) {
        let firebaseAuth = Auth.auth()
        
        guard let uid = Common.getUserDefaultsObject(forKey: .userId) else {
            onError(.uidError)
            return
        }
        
        let user = firebaseAuth.currentUser
        let userId = uid as! String
        db.collection(Constant.FStore.userCollection).document(userId).delete() { error in
            if let _ = error {
                onError(.dataError)
            }
        }
    
        user?.delete() { error in
            if let _ = error {
                onError(.databaseError)
            }
        }
        
        do {
          try firebaseAuth.signOut()
            Common.removeAllUserDefaultObject()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
