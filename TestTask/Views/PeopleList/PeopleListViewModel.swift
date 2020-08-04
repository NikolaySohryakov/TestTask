//
//  PeopleListViewModel.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import Foundation
import Combine

class PeopleListViewModel: ObservableObject {
    private(set) var repository: PeopleRepository
    
    @Published var allPeople: [Person] = []
    @Published var isLoading: Bool = false

    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(repository: PeopleRepository) {
        self.repository = repository
    }
    
    func loadPeople() {
        showError = false
        errorMessage = ""
        isLoading = true

        let loadAllPeoplePublisher = repository.loadAllPeople().receive(on: DispatchQueue.main).share()

        loadAllPeoplePublisher
                .map { _ in false }
                .replaceError(with: false)
                .assign(to: \.isLoading, on: self)
                .store(in: &cancelBag)

        loadAllPeoplePublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { people in
                self.allPeople = people
            })
            .store(in: &cancelBag)
    }

    private func handleError(_ error: RepositoryError) {
        switch error {
        case .unknown, .failedToParseJSON:
            errorMessage = "Something went wrong. Please try again."
        case .custom(let message):
            errorMessage = message
        }

        showError = true
    }
}
