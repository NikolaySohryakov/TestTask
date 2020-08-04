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
    func loadAllPeople() -> AnyPublisher<[Person], RepositoryError> {
        RequestBuilder.get(from: "/list")
                .tryMap { data, response in
                    var result: ResponseContainer<[String]>

                    do {
                        result = try JSONDecoder().decode(ResponseContainer<[String]>.self, from: data)
                    }
                    catch {
                        throw RepositoryError.failedToParseJSON
                    }

                    return result
                }
                .tryMap { (result: ResponseContainer<[String]>) -> [Person] in
                    guard case .success = result.status else {
                        if let message = result.error?.message {
                            throw RepositoryError.custom(message: message)
                        }
                        else {
                            throw RepositoryError.unknown
                        }
                    }

                    let people = result.data?.map { Person(id: $0) } ?? []

                    return people
                }
                .mapError { error in
                    switch error {
                    case is RepositoryError:
                        return error as! RepositoryError
                    default:
                        return RepositoryError.unknown
                    }
                }
                .eraseToAnyPublisher()
    }
    
    func loadPersonDetails(_ person: Person) -> AnyPublisher<Person, RepositoryError> {
        let path = "/get/\(person.id)"

        return RequestBuilder.get(from: path)
                .tryMap { data, response in
                    var result: ResponseContainer<Person>

                    do {
                        result = try JSONDecoder().decode(ResponseContainer<Person>.self, from: data)
                    }
                    catch {
                        throw RepositoryError.failedToParseJSON
                    }

                    return result
                }
                .tryMap { (result: ResponseContainer<Person>) -> Person in
                    guard case .success = result.status else {
                        if let message = result.error?.message {
                            throw RepositoryError.custom(message: message)
                        }
                        else {
                            throw RepositoryError.unknown
                        }
                    }

                    guard let person = result.data else {
                        throw RepositoryError.unknown
                    }

                    return person
                }      
                .mapError { error in
                    switch error {
                    case is RepositoryError:
                        return error as! RepositoryError
                    default:
                        return RepositoryError.unknown
                    }
                }
                .eraseToAnyPublisher()
    }
}

fileprivate final class RequestBuilder {
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
