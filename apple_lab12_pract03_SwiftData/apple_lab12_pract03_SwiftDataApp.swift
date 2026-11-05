import SwiftUI
import SwiftData

@main
struct apple_lab12_pract03_SwiftDataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Teacher.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Igual que las capturas entregadas.
        }
        .modelContainer(sharedModelContainer)
    }
}
