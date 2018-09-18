//
//  NewVaultFlow.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 16/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import Foundation

final class NewVaultFlow: FlowProtocol {
    func nextStep(state: FlowState) -> FlowStep? {
        guard !state.isCompleted else { return nil }

        guard let showSpareChange = state.isSpareChangeAllowed else { return .prepareFlow }

        guard let name = state.vaultName else { return .inputVaultName }

        guard let amount = state.vaultGoal else { return .chooseVaultGoal }

        var enableSpareChange = false
        if showSpareChange {
            guard let value = state.isSpareChangeEnabled else { return .toggleSpareChange }
            enableSpareChange = value
        }

        guard let result = state.result else { return .createVault(name, amount, enableSpareChange) }

        return .showResult(result)
    }
}
