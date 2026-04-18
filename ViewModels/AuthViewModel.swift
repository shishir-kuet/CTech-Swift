//
//  AuthViewModel.swift
//  CTechApp
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let db = Firestore.firestore()
    private let adminEmail = "admin@pcstore.com"

    func login(email: String, password: String) {
        errorMessage = nil
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                if let uid = result?.user.uid {
                    self.fetchUserRole(uid: uid, email: email)
                }
            }
        }
    }

    func register(email: String, password: String, displayName: String) {
        errorMessage = nil
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let uid = result?.user.uid else { return }

                let isAdmin = email.lowercased() == self.adminEmail
                let userData: [String: Any] = [
                    "id": uid,
                    "email": email,
                    "displayName": displayName,
                    "isAdmin": isAdmin,
                    "role": isAdmin ? "admin" : "user"
                ]
                self.db.collection("users").document(uid).setData(userData, merge: true) { error in
                    if let error = error {
                        print("Firestore register error: \(error.localizedDescription)")
                        DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
                        return
                    }
                    self.fetchUserRole(uid: uid, email: email)
                }
            }
        }
    }

    func fetchUserRole(uid: String, email: String = "") {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Firestore fetchUserRole error: \(error.localizedDescription)")
                DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
                return
            }

            guard let snapshot = snapshot, snapshot.exists else {
                // Document doesn't exist — create a basic user record on the fly
                print("No user document found for uid \(uid), creating one.")
                let isAdmin = email.lowercased() == self.adminEmail
                let userData: [String: Any] = [
                    "id": uid,
                    "email": email,
                    "isAdmin": isAdmin,
                    "role": isAdmin ? "admin" : "user"
                ]
                self.db.collection("users").document(uid).setData(userData, merge: true) { error in
                    if let error = error {
                        print("Firestore create missing user document error: \(error.localizedDescription)")
                        DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
                        return
                    }
                    let user = User(id: uid, email: email, displayName: nil, isAdmin: isAdmin)
                    DispatchQueue.main.async {
                        self.currentUser = user
                        self.isAuthenticated = true
                    }
                }
                return
            }

            // Try decoding the Firestore document
            if let user = try? snapshot.data(as: User.self) {
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                }
            } else {
                // Decoding failed — manually build User from raw data
                let data = snapshot.data() ?? [:]
                let isAdmin = data["isAdmin"] as? Bool ?? false
                let userEmail = data["email"] as? String ?? email
                let displayName = data["displayName"] as? String
                let user = User(id: uid, email: userEmail, displayName: displayName, isAdmin: isAdmin)
                print("Decoded user manually — isAdmin: \(isAdmin)")
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                }
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
}
