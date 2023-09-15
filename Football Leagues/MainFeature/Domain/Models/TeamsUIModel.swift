//
//  TeamsUIModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation

struct TeamsUIModel {
    let count: Int
    let competition: CompetitionUIModel
    let teams: [TeamUIModel]

    struct CompetitionUIModel {
        let id: Int
        let name: String
        let code: String
        let type: String
        let emblem: String
    }

    struct TeamUIModel {
        let area: AreaUIModel
        let id: Int
        let name: String
        let shortName: String
        let crest: String

        struct AreaUIModel {
            let id: Int
            let name: String
            let code: String
            let flag: String
        }
    }
}

extension TeamsUIModel {
    init(from responseModel: TeamsResponseModel) {
        self.count = responseModel.count
        self.competition = CompetitionUIModel(from: responseModel.competition)
        self.teams = responseModel.teams.map { team in
            return TeamUIModel(from: team)
        }
    }
}

extension TeamsUIModel.CompetitionUIModel {
    init(from competition: TeamsResponseModel.Competition) {
        self.id = competition.id
        self.name = competition.name
        self.code = competition.code
        self.type = competition.type
        self.emblem = competition.emblem
    }
}

extension TeamsUIModel.TeamUIModel {
    init(from team: TeamsResponseModel.Team) {
        self.area = AreaUIModel(from: team.area)
        self.id = team.id
        self.name = team.name
        self.shortName = team.shortName
        self.crest = team.crest
    }
}

extension TeamsUIModel.TeamUIModel.AreaUIModel {
    init(from area: TeamsResponseModel.Team.Area) {
        self.id = area.id
        self.name = area.name
        self.code = area.code
        self.flag = area.flag
    }
}
