//
//  ViewController.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 16/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction private func createVaultPressed(_ sender: UIButton?) {
        let flow = FlowEngine(stepPerformer: NewVaultFlowPerformer(), flow: NewVaultFlow(), initialState: NewVaultFlow.FlowState())
        flow.beginFlow()
    }

    @IBAction private func runSurveyPressed(_ sender: UIButton?) {
        let flow = FlowEngine(stepPerformer: SurveyFlowPerformer(), flow: SurveyFlow(), initialState: SurveyFlow.FlowState())
        flow.beginFlow()
    }
}
