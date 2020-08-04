//
//  TestTaskTests.swift
//  TestTaskTests
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import XCTest
import Combine
@testable import TestTask

class PeopleListViewModelTests: XCTestCase {
    var repository: TestPeopleRepository!
    var viewModel: PeopleListViewModel!

    var cancelBag: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        repository = TestPeopleRepository()
        viewModel = PeopleListViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        cancelBag.removeAll()
    }

    func testLoadPeopleSuccessful() throws {
        repository.peopleList = [
            Person(id: "id1"),
            Person(id: "id2"),
            Person(id: "id3")
        ]
        
        let expectation = XCTestExpectation()

        viewModel
                .$allPeople
                .dropFirst()
                .sink { value in
                    XCTAssertFalse(self.viewModel.showError)
                    
                    expectation.fulfill()
                }.store(in: &cancelBag)

        viewModel.loadPeople()

        wait(for: [expectation], timeout: 1)
    }

    func testLoadPeopleFailed() throws {
        repository.peopleList = []
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
        
        viewModel.loadPeople()

        wait(for: [expectation], timeout: 1)
    }

    func testIsLoading() throws {
        repository.peopleList = []

        let expectation = XCTestExpectation()

        viewModel.$isLoading
                .dropFirst(1)
                .sink {
                    XCTAssertTrue($0)

                    expectation.fulfill()
                }
                .store(in: &cancelBag)

        viewModel.loadPeople()

        wait(for: [expectation], timeout: 1)
    }
}
