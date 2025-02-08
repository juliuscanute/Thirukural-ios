//
//  ThirukuralApp.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI
import Swinject

@main
struct ThirukuralApp: App {
    let thirukuralViewModel: ThirukuralViewModel
    let searchViewModel: SearchViewModel

    init() {
        let diContainer = AppDIContainer()
        self.thirukuralViewModel = diContainer.container.resolve(ThirukuralViewModel.self)!
        self.searchViewModel = diContainer.container.resolve(SearchViewModel.self)!
    }
    
    var body: some Scene {
        WindowGroup {
            ThirukuralScreen(innerPadding: EdgeInsets(), viewModel: thirukuralViewModel, searchViewModel: searchViewModel)
        }
    }
}
