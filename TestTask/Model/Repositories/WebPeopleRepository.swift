//
//  WebPeopleRepository.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import Foundation
import Combine

class WebPeopleRepository: PeopleRepository {
    func loadAllPeople() -> AnyPublisher<[Person], Never> {
        RequestBuilder.get(from: "/list")
                .map { data, response in
                    var result: ResponseContainer<[String]>?

                    do {
                        result = try JSONDecoder().decode(ResponseContainer<[String]>.self, from: data)
                    }
                    catch(let e) {
                        print(e)
                    }

                    return result?.data.map { Person(id: $0) } ?? []
                }
                .replaceError(with: [])
                .eraseToAnyPublisher()
    }
    
    func loadPersonDetails(_ person: Person) -> AnyPublisher<Person, Never> {
        let path = "/get/\(person.id)"

        return RequestBuilder.get(from: path)
                .map { data, response in
                    var result: ResponseContainer<Person>?

                    do {
                        result = try JSONDecoder().decode(ResponseContainer<Person>.self, from: data)
                    }
                    catch(let e) {
                        print(e)
                    }

                    return result?.data ?? person
                }
                .replaceError(with: person)
                .eraseToAnyPublisher()
    }
}

final class RequestBuilder {
    private static let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE1OTY0NTY0MDUsImV4cCI6MTYyNzk5MjQwMywiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoiIiwidWlkIjoidWlkIiwiaWRlbnRpdHkiOiJpZGVudGl0eSJ9.f_6USygeyGeeNPSj4-nGFCef9rzmGYObznKFiS7VL5A"
    private static let baseURL = URL(string: "http://opn-interview-service.nn.r.appspot.com")!

    static func get(from path: String) -> URLSession.DataTaskPublisher {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: request)
    }
}
