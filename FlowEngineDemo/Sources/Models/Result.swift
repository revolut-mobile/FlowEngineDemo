//
//  Result.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 17/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
