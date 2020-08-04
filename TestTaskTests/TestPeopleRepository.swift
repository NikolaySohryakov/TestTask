//
// Created by Nikolay Sohryakov on 04.08.2020.
// Copyright (c) 2020 Storytelling Software. All rights reserved.
//

import Foundation
import Combine

class TestPeopleRepository: PeopleRepository {
    var peopleList: [Person] = []
    var personDetails: Person?

    var error: RepositoryError?

    func loadAllPeople() -> AnyPublisher<[Person], RepositoryError> {
        Future<[Person], RepositoryError> { promise in
            DispatchQueue.main.async() {
                if let error = self.error {
                    promise(.failure(error))
                    return
                }

                promise(.success(self.peopleList))
            }
        }
        .eraseToAnyPublisher()
    }

    func loadPersonDetails(_ person: Person) -> AnyPublisher<Person, RepositoryError> {
        Future<Person, RepositoryError> { promise in
            DispatchQueue.main.async() {
                if let error = self.error {
                    promise(.failure(error))
                    return
                }

                guard let personDetails = self.personDetails else {
                    promise(.failure(.unknown))
                    return
                }

                promise(.success(personDetails))
            }
        }
        .eraseToAnyPublisher()
    }


}
