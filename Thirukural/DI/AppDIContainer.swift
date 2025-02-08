//
//  AppDIContainer.swift
//  Thirukural
//
//  Created by Julius Canute on 8/2/2025.
//

import Swinject
import Foundation

@MainActor
class AppDIContainer {
    let container: Container

    init() {
        container = Container()

        container.register(ThirukuralDAO.self) { _ in
            let dbUrl = Bundle.main.url(forResource: "kural", withExtension: "sqlite")
            let dbPath = dbUrl!.path
            do {
                return try ThirukuralDAO(databasePath: dbPath)
            } catch {
                fatalError("Could not initialize ThirukuralDAO: \(error)")
            }
        }
        
        container.register(ThirukuralDataStore.self) { _ in
            ThirukuralDataStore()
        }
        
        container.register(ThirukuralRepository.self) { resolver in
            let dao = resolver.resolve(ThirukuralDAO.self)!
            let dataStore = resolver.resolve(ThirukuralDataStore.self)!
            return ThirukuralRepository(thirukuralDao: dao, thirukuralDataStore: dataStore)
        }
        
        container.register(KuralViewStateMapper.self) { _ in
            KuralViewStateMapper()
        }
        
        container.register(SearchViewStateMapper.self) { _ in
            SearchViewStateMapper()
        }
        
        container.register(ThirukuralViewModel.self) { resolver in
            let repository = resolver.resolve(ThirukuralRepository.self)!
            let mapper = resolver.resolve(KuralViewStateMapper.self)!
            return ThirukuralViewModel(kuralRepository: repository, kuralViewStateMapper: mapper)
        }
        
        container.register(SearchViewModel.self) { resolver in
            let repository = resolver.resolve(ThirukuralRepository.self)!
            let mapper = resolver.resolve(SearchViewStateMapper.self)!
            return SearchViewModel(repository: repository, searchViewStateMapper: mapper)
        }
    }
}
