//
//  PeopleRepository.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import Foundation
import Combine

protocol PeopleRepository {
    func loadAllPeople() -> AnyPublisher<[Person], RepositoryError>
    func loadPersonDetails(_ person: Person) -> AnyPublisher<Person, RepositoryError>
}
