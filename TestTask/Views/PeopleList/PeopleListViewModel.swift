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
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(repository: PeopleRepository) {
        self.repository = repository
    }
    
    func loadPeople() {
        isLoading = true

        let loadAllPeoplePublisher = repository.loadAllPeople().receive(on: DispatchQueue.main).share()

        loadAllPeoplePublisher
                .map { _ in false }
                .assign(to: \.isLoading, on: self)
                .store(in: &cancelBag)

        loadAllPeoplePublisher
            .assign(to: \.allPeople, on: self)
            .store(in: &cancelBag)
    }
}
