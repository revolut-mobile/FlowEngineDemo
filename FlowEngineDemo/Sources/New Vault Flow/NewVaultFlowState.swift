//
//  NewVaultFlowState.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 16/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import Foundation

extension NewVaultFlow {
    enum FlowStep {
        case prepareFlow
        case inputVaultName
        case chooseVaultGoal
        case toggleSpareChange
        case createVault(String, MoneyItem, Bool)
        case showResult(Result<Vault>)
    }

    struct FlowState {
        private (set) var isCompleted = false
        private (set) var isSpareChangeAllowed: Bool?
        private (set) var vaultName: String?
        private (set) var vaultGoal: MoneyItem?
        private (set) var isSpareChangeEnabled: Bool?
        private (set) var result: Result<Vault>?
    }
}

extension NewVaultFlow.FlowState: FlowStateProtocol {
    enum MutatingAction {
        case setOptions(spareChangeAllowed: Bool)
        case setVaultName(String)
        case setVaultGoal(MoneyItem)
        case setSpareChange(Bool)
        case setResult(Result<Vault>)
        case setComplete
    }

    mutating func mutate(with action: NewVaultFlow.FlowState.MutatingAction) {
        switch action {
        case let .setOptions(spareChangeAllowed):   self.isSpareChangeAllowed = spareChangeAllowed
        case let .setVaultName(name):               self.vaultName = name
        case let .setVaultGoal(goal):               self.vaultGoal = goal
        case let .setSpareChange(enabled):          self.isSpareChangeEnabled = enabled
        case let .setResult(result):                self.result = result
        case .setComplete:                          self.isCompleted = true
        }
    }
}
