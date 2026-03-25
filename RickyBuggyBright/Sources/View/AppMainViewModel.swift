//
//  AppMainViewModel.swift
//  RickyBuggyBright
//

import Combine
import Foundation

final class AppMainViewModel: ObservableObject {
    @Published var showsSortActionSheet: Bool = false
    @Published var sortMethod: SortMethod = .name
    @Published var characters: [CharacterResponseModel] = []

    @Published private(set) var characterErrors: [APIError] = []
    @Published private(set) var sortMethodDescription: String = "Choose Sorting"

    private let showsSortActionSheetSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let sortMethodSubject = CurrentValueSubject<SortMethod?, Never>(nil)

    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        sortMethodSubject
            .compactMap { $0 }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] sortMethod in
                self?.sortMethod = sortMethod
                self?.sortMethodDescription = sortMethod.description
                self?.requestData()
            })
            .store(in: &cancellables)
        
        showsSortActionSheetSubject
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.showsSortActionSheet, on: self)
            .store(in: &cancellables)
        
        requestData()
    }
    
    func setSortMethod(_ sortMethod: SortMethod) {
        sortMethodSubject.send(sortMethod)
    }
    
    func setShowsSortActionSheet() {
        showsSortActionSheetSubject.send(true)
    }
    
    func requestData() {
        #if DEBUG
        debugPrint("Fetching data")
        #endif
        
        characterErrors.removeAll()

        isLoading = true

        let apiService = DIContainer.shared.resolve(APIClient.self)
        
        apiService?.charactersPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.characterErrors.append(error)
                case .finished:
                    break
                }
                
                self?.isLoading = false
            }, receiveValue: { [weak self] characters in
                if let sortMethod = self?.sortMethod {
                    self?.characters = characters.sortBy(sortMethod)
                } else {
                    self?.characters = characters
                }
            })
            .store(in: &cancellables)
    }
}

private extension Array where Element == CharacterResponseModel {
    func sortBy(_ sortMethod: SortMethod) -> [CharacterResponseModel] {
        switch sortMethod {
        case .name: sorted(by: { $0.name > $1.name })
        case .episodesCount: sorted(by: { $0.episode.count > $1.episode.count })
        }
    }
}
