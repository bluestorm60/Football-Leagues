//
//  File.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

protocol LeaguesUseCase {
    var loadingPublisher: Published<LoadingState>.Publisher { get }
    func fetchCompetitions() async throws -> AppResponse<LeaguesUIModel>
    func fetchTeams(competionCode: String) async throws -> AppResponse<TeamsUIModel>
    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchUIModel>
}

final class LeaguesUseCaseImpl{
    @Published private var loading: LoadingState = .none

    private let repository: FootballLeaguesRepository
    var loadingPublisher: Published<LoadingState>.Publisher {$loading}

    init(repository: FootballLeaguesRepository) {
        self.repository = repository
    }
}

extension LeaguesUseCaseImpl: LeaguesUseCase{
    func fetchCompetitions() async throws -> AppResponse<LeaguesUIModel> {
        loading = .loading
        let response: AppResponse<LeaguesUIModel> = try await fetchCompetitionsRemotely()
        switch response {
        case .success(let response):
            let result = await handleSuccessResponseCompetitions(response)
            loading = .dismiss
            return .success(result)
        case .error(let networkError):
            loading = .dismiss
            return .error(networkError)
        }
    }
    private func handleSuccessResponseCompetitions(_ response: LeaguesUIModel) async -> LeaguesUIModel{
        let teams = try? await getCompetitionTeams(items: response.competitions)
        let matches = try? await getCompetitionMatches(items: teams ?? response.competitions)
        var result = response
        result.competitions = matches ?? response.competitions
        return response
    }
    
    private func fetchCompetitionsRemotely() async throws -> AppResponse<LeaguesUIModel>{
        let networkResult: AppResponse<LeaguesResponseModel> = try await repository.fetchCompetitions()
        switch networkResult {
        case .success(let leaguesResponse):
            // Convert the network response to UIModel
            let uiModel = LeaguesUIModel(from: leaguesResponse)
            return .success(uiModel)
        case .error(let error):
            // Propagate any network errors
            return .error(error)
        }
    }
    
    private func getCompetitionTeams(items: [LeaguesUIModel.CompetitionUIModel]) async throws -> [LeaguesUIModel.CompetitionUIModel]{
        let allReaults = try await withThrowingTaskGroup(of: AppResponse<TeamsUIModel>.self, returning: [LeaguesUIModel.CompetitionUIModel].self, body: { taskGroup in
            let list = items
            for item in list{
                taskGroup.addTask {
                    return try await self.fetchTeams(competionCode: item.code)
                }
            }
            var teams = [LeaguesUIModel.CompetitionUIModel]()
            /// Note the use of `next()`:
            while let team = try await taskGroup.next() {
                switch team {
                case .success(let model):
                    if var competition = list.first(where: {$0.code == model.competition.code}){
                        competition.numberOfTeams = "\(model.count)"
                        teams.append(competition)
                    }
                case .error(let error):
                    throw error
                }
            }
            return teams
        })
        return allReaults
    }
    
    private func getCompetitionMatches(items: [LeaguesUIModel.CompetitionUIModel]) async throws -> [LeaguesUIModel.CompetitionUIModel]{
        let allReaults = try await withThrowingTaskGroup(of: AppResponse<CompetitionMatchUIModel>.self, returning: [LeaguesUIModel.CompetitionUIModel].self, body: { taskGroup in
            let list = items
            for item in list{
//                try await Task.sleep(nanoseconds: 50_000_000_000)
                taskGroup.addTask {try await self.fetchMatches(competionCode: item.code)}
            }
            var teams = [LeaguesUIModel.CompetitionUIModel]()

            /// Note the use of `next()`:
            while let team = try await taskGroup.next() {
                switch team {
                case .success(let model):
                    if var competition = list.first(where: {$0.code == model.competition.code}){
                        competition.numberOfTeams = "\(model.resultSet.count)"
                        teams.append(competition)
                    }

                case .error(let error):
                    throw error
                }
            }
            return teams
        })
        return allReaults
    }
}

extension LeaguesUseCaseImpl{
    func fetchTeams(competionCode: String) async throws -> AppResponse<TeamsUIModel> {
        let networkResult: AppResponse<TeamsResponseModel> = try await repository.fetchTeams(competionCode: competionCode)
        switch networkResult {
        case .success(let teamsResponse):
            // Convert the network response to UIModel
            let uiModel = TeamsUIModel(from: teamsResponse)
            return .success(uiModel)
        case .error(let error):
            // Propagate any network errors
            return .error(error)
        }
    }
    
}

extension LeaguesUseCaseImpl{
    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchUIModel> {
        let networkResult: AppResponse<CompetitionMatchResponseModel> = try await repository.fetchMatches(competionCode: competionCode)
        switch networkResult {
        case .success(let matchesResponse):
            // Convert the network response to UIModel
            let uiModel = CompetitionMatchUIModel(from: matchesResponse)
            return .success(uiModel)
        case .error(let error):
            // Propagate any network errors
            return .error(error)
        }
    }
}
