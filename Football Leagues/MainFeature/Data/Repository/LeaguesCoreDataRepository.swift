//
//  CoreDataRepository.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import CoreData



protocol LeaguesCoreDataRepository {
    func fetchLeagues() async throws -> AppResponse<LeaguesUIModel>
    func saveLeagues(_ leagues: LeaguesUIModel) async throws -> AppResponse<Void>
    
    func fetchTeams(competionCode: String) async throws -> AppResponse<TeamsUIModel>
    func saveTeams(_ leagues: TeamsUIModel) async throws -> AppResponse<Void>

    func fetchMatches(competionCode: String) async throws -> AppResponse<CompetitionMatchUIModel>
}

//class CoreDataRepositoryImpl: CoreDataRepository {
//    
//    private let managedObjectContext: NSManagedObjectContext
//    
//    init(managedObjectContext: NSManagedObjectContext) {
//        self.managedObjectContext = managedObjectContext
//    }
//    
//    func fetchLeagues() async throws -> AppResponse<LeaguesUIModel> {
//        return try await withCheckedThrowingContinuation { continuation in
//            let fetchRequest: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
//            
//            do {
//                let leagueEntities = try managedObjectContext.fetch(fetchRequest)
//                
//                let leaguesUIModel = LeaguesUIModel(leagues: leagueEntities.map { leagueEntity in
//                    return LeaguesUIModel.LeagueInfoUIModel(
//                        name: leagueEntity.name ?? "",
//                        logo: leagueEntity.logo ?? "",
//                        numberOfTeams: Int(leagueEntity.numberOfTeams),
//                        numberOfGames: Int(leagueEntity.numberOfGames),
//                        numberOfSeasons: Int(leagueEntity.numberOfSeasons)
//                    )
//                })
//                
//                continuation.resume(returning: .success(leaguesUIModel))
//            } catch {
//                continuation.resume(returning: .error(NetworkError.error(error.localizedDescription)))
//            }
//        }
//    }
//    
//    func saveLeagues(_ leagues: LeaguesUIModel) async throws -> AppResponse<Void> {
//        return try await withCheckedThrowingContinuation { continuation in
//            let batchInsertRequest = NSBatchInsertRequest(
//                entityName: String(describing: LeagueEntity.self),
//                objects: leagues.competitions.map { leagueInfo in
//                    return [
//                        "name": leagueInfo.name,
//                        "logo": leagueInfo.emblem,
//                        "numberOfTeams": leagueInfo.numberOfTeams,
//                        "numberOfGames": leagueInfo.numberOfGames,
//                        "numberOfSeasons": leagueInfo.numberOfSeasons
//                    ]
//                }
//            )
//            
//            do {
//                try managedObjectContext.execute(batchInsertRequest)
//                try managedObjectContext.save()
//                continuation.resume(returning: .success(()))
//            } catch {
//                continuation.resume(returning: .error(NetworkError.error(error.localizedDescription)))
//            }
//        }
//    }
//}
