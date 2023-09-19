//
//  CompetitionsURLRequest.swift
//  WW-Exercise-01
//
//  Created by Ahmed Shafik on 13/09/2023.
//  Copyright © 2023 Weight Watchers. All rights reserved.
//

import Foundation

enum FootballLeaguesURLRequest: BaseURLRequest{
    case leagues
    case teams(competionCode: String)
    case matches(competionCode: String)
    case teamMatchs(teamId: Int)
    
    var method: HTTPMethod {
        switch self{
        case .leagues,.teams,.matches,.teamMatchs:
            return .get
        }
    }
    
    var path: String{
        switch self{
        case .leagues:
            return "competitions"
        case .teams(let competionCode):
            return "competitions/\(competionCode)/teams"
        case .matches(let competionCode):
            return "competitions/\(competionCode)/matches"
        case .teamMatchs(let teamId):
            return "teams/\(teamId)/matches"
        }
    }
    
    var headers: [String : String]?{
        return ["X-Auth-Token": "e29c2cf472b243f28e0f83afece75404"]
    }
}
