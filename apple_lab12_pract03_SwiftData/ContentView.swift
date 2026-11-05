import SwiftUI
import SwiftData

// Pantalla principal: título, botón +, buscador y lista de docentes.
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Teacher.firstName) private var teachers: [Teacher]
    @State private var searchText = ""
    @State private var showingAddTeacher = false
    @State private var teacherToEdit: Teacher?
    @State private var teacherToDelete: Teacher?

    private var filteredTeachers: [Teacher] {
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return teachers }
        return teachers.filter {
            $0.firstName.localizedCaseInsensitiveContains(term) ||
            $0.lastName.localizedCaseInsensitiveContains(term) ||
            $0.fullName.localizedCaseInsensitiveContains(term) ||
            $0.specialty.localizedCaseInsensitiveContains(term) ||
            $0.email.localizedCaseInsensitiveContains(term)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    HStack {
                        TextField("Search teachers...", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                            .accessibilityLabel("Clear search")
                        }
                    }
                    .padding(.horizontal, 7)
                    .frame(height: 31)
                    .background(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemGray5)))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 6)

                List {
                    ForEach(filteredTeachers) { teacher in
                        Button {
                            teacherToEdit = teacher
                        } label: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(teacher.fullName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.primary)
                                Text(teacher.specialty)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.blue)
                                Text(teacher.email)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 3)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                teacherToDelete = teacher
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(Color.white)
            .navigationTitle("Teachers")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddTeacher = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .regular))
                    }
                    .accessibilityLabel("Add Teacher")
                }
            }
            .sheet(isPresented: $showingAddTeacher) {
                TeacherFormView(teacher: nil)
            }
            .sheet(item: $teacherToEdit) { teacher in
                TeacherFormView(teacher: teacher)
            }
            .confirmationDialog("Delete Teacher?", isPresented: Binding(
                get: { teacherToDelete != nil },
                set: { if !$0 { teacherToDelete = nil } }
            ), titleVisibility: .visible) {
                Button("Delete Teacher", role: .destructive) {
                    if let teacherToDelete {
                        modelContext.delete(teacherToDelete)
                        try? modelContext.save()
                    }
                    teacherToDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    teacherToDelete = nil
                }
            } message: {
                Text("This teacher will be permanently deleted.")
            }
        }
        .tint(.blue)
    }
}

// Un mismo formulario se usa tanto para crear como para editar.
struct TeacherFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let teacher: Teacher?
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String
    @State private var birthDate: Date
    @State private var specialty: String
    @State private var hireDate: Date
    @State private var isActive: Bool
    @State private var showDeleteConfirmation = false
    @State private var showValidationError = false
    @State private var errorMessage = ""

    init(teacher: Teacher?) {
        self.teacher = teacher
        _firstName = State(initialValue: teacher?.firstName ?? "")
        _lastName = State(initialValue: teacher?.lastName ?? "")
        _email = State(initialValue: teacher?.email ?? "")
        _phone = State(initialValue: teacher?.phone ?? "")
        _birthDate = State(initialValue: teacher?.birthDate ?? Calendar.current.date(from: DateComponents(year: 2022, month: 8, day: 1)) ?? .now)
        _specialty = State(initialValue: teacher?.specialty ?? "")
        _hireDate = State(initialValue: teacher?.hireDate ?? Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 1)) ?? .now)
        _isActive = State(initialValue: teacher?.isActive ?? true)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("PERSONAL INFORMATION") {
                    TextField("First Name", text: $firstName)
                        .textContentType(.givenName)
                    TextField("Last Name", text: $lastName)
                        .textContentType(.familyName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                    DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
                }

                Section("PROFESSIONAL INFORMATION") {
                    TextField("Specialty", text: $specialty)
                    DatePicker("Hire Date", selection: $hireDate, displayedComponents: .date)
                    Toggle("Active", isOn: $isActive)
                }

                if teacher != nil {
                    Section {
                        Button("Delete Teacher", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    }
                }
            }
            .navigationTitle(teacher == nil ? "Add Teacher" : "Edit Teacher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveTeacher() }
                }
            }
            .alert("Unable to save", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .confirmationDialog("Delete Teacher?", isPresented: $showDeleteConfirmation,
                                titleVisibility: .visible) {
                Button("Delete Teacher", role: .destructive) {
                    if let teacher {
                        modelContext.delete(teacher)
                        do {
                            try modelContext.save()
                            dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                            showValidationError = true
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This teacher will be permanently deleted.")
            }
        }
        .tint(.blue)
    }

    private func saveTeacher() {
        let name = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let surname = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let mail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let telephone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let job = specialty.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty, !surname.isEmpty, !mail.isEmpty, !telephone.isEmpty, !job.isEmpty else {
            errorMessage = "Complete all personal and professional information fields."
            showValidationError = true
            return
        }
        guard mail.contains("@"), mail.split(separator: "@").last?.contains(".") == true else {
            errorMessage = "Enter a valid email address."
            showValidationError = true
            return
        }

        if let teacher {
            teacher.firstName = name
            teacher.lastName = surname
            teacher.email = mail
            teacher.phone = telephone
            teacher.birthDate = birthDate
            teacher.specialty = job
            teacher.hireDate = hireDate
            teacher.isActive = isActive
        } else {
            modelContext.insert(Teacher(firstName: name, lastName: surname, email: mail,
                                        phone: telephone, birthDate: birthDate, specialty: job,
                                        hireDate: hireDate, isActive: isActive))
        }
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showValidationError = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Teacher.self, inMemory: true)
}
