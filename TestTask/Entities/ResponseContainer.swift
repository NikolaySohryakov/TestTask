//
// Created by Nikolay Sohryakov on 03.08.2020.
// Copyright (c) 2020 Storytelling Software. All rights reserved.
//

import Foundation

struct ResponseContainer<T: Codable>: Codable {
    var status: String
    var data: T
}
