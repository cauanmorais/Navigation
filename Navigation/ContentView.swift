//
//  ContentView.swift
//  Navigation
//
//  Created by Cauan de Jesus Nascimento de Morais on 01/11/26.
//

import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
        
        // Still here? Start with an empty path
        path = NavigationPath()
    }
    
    func save() {
        do {
            guard let representation = path.codable else { return }
            
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

struct ContentView: View {
    @State private var pathStore = PathStore()
    @State private var title = "Sekiro"
    
    var body: some View {
//        NavigationStack(path: $pathStore.path) {
//            detailView(number: 0, path: $pathStore.path)
//                .navigationDestination(for: Int.self) { i in
//                    detailView(number: i, path: $pathStore.path)
//                }
//        }
        NavigationStack {
            Text("Hello World")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct detailView: View {
    let number: Int
    @Binding var path: NavigationPath
    @State private var title = "SwiftUI"
    
    var body: some View {
        NavigationLink("Choose a random number", value: Int.random(in: 0...10))
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem {
                    Button("House", systemImage: "house") {
                        path = NavigationPath()
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
