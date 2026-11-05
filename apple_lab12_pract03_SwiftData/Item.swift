import Foundation
import SwiftData

// Modelo persistente del docente: SwiftData guarda los cambios entre ejecuciones.
@Model
final class Teacher {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var birthDate: Date
    var specialty: String
    var hireDate: Date
    var isActive: Bool

    init(firstName: String, lastName: String, email: String, phone: String,
         birthDate: Date, specialty: String, hireDate: Date, isActive: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.birthDate = birthDate
        self.specialty = specialty
        self.hireDate = hireDate
        self.isActive = isActive
    }

    var fullName: String { "\(firstName) \(lastName)" }
}
