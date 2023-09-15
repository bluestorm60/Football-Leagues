//
//  File.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct LeaguesUIModel {
    let count: Int
    var competitions: [CompetitionUIModel]
    struct CompetitionUIModel {
        let id: Int
        let name: String
        let areaName: String
        let code: String
        let type: String
        let emblem: String
        var numberOfmatches: String = "NA"
        var numberOfTeams: String = "NA"
        var numberOfSeasons: String = "NA"
    }
    
    init(from responseModel: LeaguesResponseModel) {
        self.count = responseModel.count
        self.competitions = responseModel.competitions.map { competition in
            return CompetitionUIModel(
                id: competition.id,
                name: competition.name,
                areaName: competition.area.name,
                code: competition.code,
                type: competition.type,
                emblem: competition.emblem,
                numberOfSeasons: "\(competition.numberOfAvailableSeasons)"
            )
        }
    }
}
