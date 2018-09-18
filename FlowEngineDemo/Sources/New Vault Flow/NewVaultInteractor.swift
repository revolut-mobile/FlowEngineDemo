//
//  NewVaultInteractor.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 18/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import Foundation

final class NewVaultInteractor {
    func checkSpareChangeAvailability() -> Bool {
        return true
    }

    func createNewVault(name: String, goal: MoneyItem, enableSpareChange: Bool, completion: @escaping (Result<Vault>) -> Void) {
        // todo: send requests and process results
        let vault = Vault(name: name, goal: goal, isSpareChangeEnabled: enableSpareChange)
        completion(.success(vault))
    }
}
