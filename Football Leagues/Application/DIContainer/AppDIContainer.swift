//
//  AppDIContainer.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 19/09/2023.
//

import Foundation

final class AppDIContainer {
    

    // MARK: - Network
    lazy var apiDataTransferService: NetworkProtocol = { return Network.shared } ()
//    lazy var dataStorageService: NetworkProtocol = { return CoreDataManager.shared } ()

    // MARK: - DIContainers of scenes
    func makeLeaguesSceneDIContainer() -> LeaguesDIContainer {
        let dependencies = LeaguesDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return LeaguesDIContainer(dependencies: dependencies)
    }
}
