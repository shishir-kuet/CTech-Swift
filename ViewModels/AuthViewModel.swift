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
    
    private var db = Firestore.firestore()

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let uid = result?.user.uid {
                self.fetchUserRole(uid: uid)
            }
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
