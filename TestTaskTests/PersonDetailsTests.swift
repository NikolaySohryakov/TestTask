//
//  PersonDetailsTests.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 04.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import XCTest
import Combine
@testable import TestTask

class PersonDetailsTests: XCTestCase {
    var repository: TestPeopleRepository!
    var viewModel: PersonDetailsViewModel!

    var cancelBag: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        repository = TestPeopleRepository()
        let person = Person(id: "id")
        viewModel = PersonDetailsViewModel(repository: repository, person: person)

        let fullPersonDetails = Person(
                id: "id",
                firstName: "John",
                lastName: "Doe",
                age: 21,
                gender: "Male",
                country: "US")
        repository.personDetails = fullPersonDetails
    }

    override func tearDownWithError() throws {
        cancelBag.removeAll()
    }

    func testLoadPersonDetailsSuccessful() throws {
        let expectation = XCTestExpectation()

        viewModel.$person
                .dropFirst()
                .sink { _ in
                    XCTAssertFalse(self.viewModel.showError)

                    expectation.fulfill()
                }
                .store(in: &cancelBag)

        viewModel.loadPersonDetails()
    }

    func testIsLoading() throws {
        let expectation = XCTestExpectation()

        viewModel.$isLoading
                .dropFirst(1)
                .sink {
                    XCTAssertTrue($0)

                    expectation.fulfill()
                }
                .store(in: &cancelBag)

        viewModel.loadPersonDetails()

        wait(for: [expectation], timeout: 1)
    }

    func testLoadPersonDetailsFailed() throws {
        repository.personDetails = nil
        repository.error = .unknown

        let expectation = XCTestExpectation()

        viewModel.$showError
                .dropFirst(2)
                .sink {
                    XCTAssertTrue($0)
                    XCTAssertNotEqual(self.viewModel.errorMessage, "")

                    expectation.fulfill()
                }
                .store(in: &cancelBag)

        viewModel.loadPersonDetails()

        wait(for: [expectation], timeout: 1)
    }
}
