//
//  ThirukuralViewModel.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import Foundation
import Combine

@MainActor
class ThirukuralViewModel: ObservableObject {
    @Published var kuralViewState: ThirukuralViewState?
    @Published var navigationViewState: NavigationViewState?
    
    var totalCount: Int = 0
    
    private let kuralRepository: ThirukuralRepository
    private let kuralViewStateMapper: KuralViewStateMapper
    
    init(kuralRepository: ThirukuralRepository,
         kuralViewStateMapper: KuralViewStateMapper) {
        self.kuralRepository = kuralRepository
        self.kuralViewStateMapper = kuralViewStateMapper
        
        // Launch initial data load in an asynchronous task.
        Task {
            await self.loadInitialData()
        }
    }
    
    private func loadInitialData() async {
        let count = await kuralRepository.getThirukuralCount()
        
        await MainActor.run {
            self.totalCount = count
        }
        let savedKural = kuralRepository.kuralNumber
        await loadKural(kuralNo: savedKural)
    }
    
    func loadKural(kuralNo: Int) async {
        if let kuralWithDetails = await kuralRepository.getThirukuralWithDetails(kuralNumber: kuralNo) {
            self.kuralViewState = kuralViewStateMapper.mapToViewState(kuralWithDetails: kuralWithDetails)
        }
        kuralRepository.saveKuralNumber(kuralNo)
        await updateNavigationState(kuralNo: kuralNo)
    }
    
    func loadPreviousKural(_ kuralNo: Int?) async {
        guard let kuralNo = kuralNo, kuralNo > 1 else { return }
        await loadKural(kuralNo: kuralNo - 1)
        await updateNavigationState(kuralNo: kuralNo - 1)
    }
    
    func loadNextKural(_ kuralNo: Int?) async {
        guard let kuralNo = kuralNo, kuralNo < totalCount else { return }
        await loadKural(kuralNo: kuralNo + 1)
        await updateNavigationState(kuralNo: kuralNo + 1)
    }
    
    func updateNavigationState(kuralNo: Int) async {
        navigationViewState = await kuralViewStateMapper.mapToNavigationState(viewModel: self, kuralNumber: kuralNo, totalCount: totalCount)
    }
}
