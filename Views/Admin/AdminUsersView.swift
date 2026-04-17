import SwiftUI
import FirebaseFirestore

struct AdminUsersView: View {
    @State private var users: [User] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showAddUser = false

    var body: some View {
        List {
            if let errorMessage = errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }

            if users.isEmpty && isLoading {
                ProgressView("Loading users...")
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            ForEach(users) { user in
                HStack {
                    VStack(alignment: .leading) {
                        Text(user.displayName ?? user.email)
                            .font(.headline)
                        Text(user.email)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if user.isAdmin {
                        Text("Admin")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        removeUser(user)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("Manage Users")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddUser = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear(perform: loadUsers)
        .sheet(isPresented: $showAddUser) {
            AddUserView { loadUsers() }
        }
    }

    private func loadUsers() {
        isLoading = true
        errorMessage = nil

        Firestore.firestore().collection("users")
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                users = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let id = data["id"] as? String ?? document.documentID
                    let email = data["email"] as? String ?? "unknown@example.com"
                    let displayName = data["displayName"] as? String
                    let isAdmin = data["isAdmin"] as? Bool ?? false
                    return User(id: id, email: email, displayName: displayName, isAdmin: isAdmin)
                } ?? []
            }
    }

    private func removeUser(_ user: User) {
        Firestore.firestore().collection("users").document(user.id).delete { error in
            if let error = error {
                errorMessage = "Failed to remove user: \(error.localizedDescription)"
                return
            }
            users.removeAll { $0.id == user.id }
        }
    }
}

private struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var isAdmin = false
    @State private var errorMessage: String?

    let onSaved: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Info")) {
                    TextField("Full name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    Toggle("Admin user", isOn: $isAdmin)
                }

                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add User")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { addUser() }
                        .disabled(name.isEmpty || email.isEmpty)
                }
            }
        }
    }

    private func addUser() {
        guard !name.isEmpty, !email.isEmpty else {
            errorMessage = "Please fill the user details."
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document()
        let newUser: [String: Any] = [
            "displayName": name,
            "email": email,
            "isAdmin": isAdmin,
            "createdAt": Timestamp(date: Date())
        ]

        userRef.setData(newUser) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            onSaved()
            dismiss()
        }
    }
}
