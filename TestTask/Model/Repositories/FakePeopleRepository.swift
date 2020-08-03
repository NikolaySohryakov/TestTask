//
//  FakePeopleRepository.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import Foundation
import Combine

class FakePeopleRepository: PeopleRepository {
    func loadAllPeople() -> AnyPublisher<[Person], Never> {
        Future<[Person], Never> { promise in
            let people = [
                Person(id: "id1"),
                Person(id: "id2")
            ]

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                promise(.success(people))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadPersonDetails(_ person: Person) -> AnyPublisher<Person, Never> {
        Future<Person, Never> { promise in
            var person = Person(id: "id1")
            person.firstName = "first name"
            person.lastName = "last name"

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                promise(.success(person))
            }
        }
        .eraseToAnyPublisher()
    }
}
