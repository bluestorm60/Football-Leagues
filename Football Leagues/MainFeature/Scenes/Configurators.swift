//
//  Configurators.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 12/09/2023.
//

import UIKit

enum Configurators{
    case leagues(coordinator: MainCoordinator?)
    case teams(coordinator: MainCoordinator?,_ useCase: LeaguesUseCase,_ item: LeaguesUIModel.CompetitionUIModel)
    case teamDetails(item: TeamsUIModel.TeamUIModel, coordinator: MainCoordinator?)
    
    func getViewController() -> UIViewController{
        switch self {
        case .leagues(let coordinator):
            return leaguesViewController(coordinator: coordinator)
        case .teams(let coordinator, let useCase, let item):
            return teamsViewController(coordinator: coordinator, useCase, item)
        case .teamDetails(let item, let coordinator):
            return teamsDetailsViewController(item: item, coordinator: coordinator)
        }
    }
    
    private func leaguesViewController(coordinator: MainCoordinator?) -> UIViewController{
        let network = Network.shared
        let repository = FootballLeaguesRepositoryImpl(network: network)
        let coreDataRepo = CoreDataUseCaseImpl(manager: CoreDataManager.shared)
        let useCase = LeaguesUseCaseImpl(repository: repository, coreDataRepository: coreDataRepo)
        let viewModel = LeaguesViewModel(coordinator: coordinator, useCase: useCase)
        return LeaguesViewController(viewModel: viewModel)
    }
    
    private func teamsViewController(coordinator: MainCoordinator?,_ useCase: LeaguesUseCase,_ item: LeaguesUIModel.CompetitionUIModel) -> UIViewController{
        let viewModel = TeamsViewModel(coordinator: coordinator, useCase: useCase, item: item)
        return TeamsViewController(viewModel: viewModel)
    }
    
    private func teamsDetailsViewController(item: TeamsUIModel.TeamUIModel, coordinator: MainCoordinator?) -> UIViewController{
        let network = Network.shared
        let repo = FootballLeaguesRepositoryImpl(network: network)
        let useCase = TeamsMatchsUseCaseImpl(repository: repo)
        let viewModel = TeamDetailsViewModel(coordinator: coordinator, useCase: useCase, item: item)
        return TeamDetailsViewController(viewModel: viewModel)
    }
}
