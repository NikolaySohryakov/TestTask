//
//  PersonDetailsViewModel.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import Foundation
import Combine

class PersonDetailsViewModel: ObservableObject {
    private(set) var repository: PeopleRepository
    
    private var cancelBag: Set<AnyCancellable> = []
    
    @Published var person: Person
    @Published var isLoading: Bool = false

    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init(repository: PeopleRepository, person: Person) {
        self.repository = repository
        self.person = person
    }
    
    func loadPersonDetails() {
        isLoading = true

        let personDetailsPublisher = repository.loadPersonDetails(person).receive(on: DispatchQueue.main).share()

        personDetailsPublisher
                .map { _ in false }
                .replaceError(with: false)
                .assign(to: \.isLoading, on: self)
                .store(in: &cancelBag)

        personDetailsPublisher
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.handleError(error)
                    }
                }, receiveValue: { person in
                    self.person = person
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
