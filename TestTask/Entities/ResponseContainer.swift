//
// Created by Nikolay Sohryakov on 03.08.2020.
// Copyright (c) 2020 Storytelling Software. All rights reserved.
//

import Foundation

struct ResponseContainer<T: Codable>: Codable {
    enum ResponseStatus: String, Codable {
        case success = "success"
        case error = "error"
    }

    var status: ResponseStatus
    var data: T?
    var error: ResponseError?
}
