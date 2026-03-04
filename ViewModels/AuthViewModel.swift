//
//  AuthViewModel.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    private var db = Firestore.firestore()

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            if let uid = result?.user.uid {
                self.fetchUserRole(uid: uid)
            }
        }
    }
    
    func register(email: String, password: String, isAdmin: Bool = false) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let newUser = User(id: uid, email: email, isAdmin: isAdmin)
            
            do {
                try self.db.collection("users").document(uid).setData(from: newUser) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        self.fetchUserRole(uid: uid)
                    }
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func logout() {
        try? Auth.auth().signOut()
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }

    func fetchUserRole(uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, _ in
            if let user = try? snapshot?.data(as: User.self) {
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                }
            }
        }
    }
}
