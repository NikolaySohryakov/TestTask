//
// Created by Nikolay Sohryakov on 03.08.2020.
// Copyright (c) 2020 Storytelling Software. All rights reserved.
//

import Foundation

enum RepositoryError: Error {
    case failedToParseJSON
    case unknown
    case custom(message: String)
}
