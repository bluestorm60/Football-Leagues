//
//  LeaguesViewModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation
import Combine

//MARK: - Input Protocol
protocol LeaguesViewModelInput{
    func viewWillAppear()
    func numberOfRowsInSection() -> Int
}

//MARK: - Output Protocol
protocol LeaguesViewModelOutput{
    var listPublisher: Published<[CompetitionCellViewModel]>.Publisher { get }
    var loadingPublisher: Published<LoadingState>.Publisher { get }
    var errorMsgPublisher: Published<String?>.Publisher { get }
}

typealias LeaguesViewModelProtocols = LeaguesViewModelInput & LeaguesViewModelOutput


final class LeaguesViewModel: ObservableObject,  LeaguesViewModelProtocols{
    @Published private var list: [CompetitionCellViewModel] = []
    @Published private var loading: LoadingState = .none
    @Published private var errorMsg: String?

    var coordinator: MainCoordinator?
    let useCase: LeaguesUseCase
    private var cancellables = Set<AnyCancellable>()

    //MARK: - Outputs
    var listPublisher: Published<[CompetitionCellViewModel]>.Publisher {$list}
    var loadingPublisher: Published<LoadingState>.Publisher {$loading}
    var errorMsgPublisher: Published<String?>.Publisher {$errorMsg}

    //MARK: - Init
    init(coordinator: MainCoordinator? = nil, useCase: LeaguesUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.useCase.loadingPublisher.assignNoRetain(to: \.loading, on: self).store(in: &cancellables)
    }
    
}

//MARK: - Requests
extension LeaguesViewModel{
     private func requests(){
        Task {
          let response =  try await useCase.fetchCompetitions()
            switch response {
            case .success(let result):
                let cellViewModels = convertToCellModels(result)
                list = cellViewModels
            case .error(let networkError):
                errorMsg = networkError.localizedDescription
            }
        }
    }
    
    private func convertToCellModels(_ item: LeaguesUIModel) -> [CompetitionCellViewModel]{
        return item.competitions.map { item in
            return .init(item, self)
        }
    }
}

//MARK: - Input
extension LeaguesViewModel {
    func viewWillAppear() {
        requests()
    }
    
    func numberOfRowsInSection() -> Int {
        return list.count
    }
    
    func cellForRow(_ indexPath: IndexPath) -> CompetitionCellViewModel{
        return list[indexPath.row]
    }
}

//MARK: - CompetitionCellsDelegate
extension LeaguesViewModel: CompetitionCellViewModelDelegate{
    func openCompetition(item: LeaguesUIModel.CompetitionUIModel?) {
        guard let item = item else {return}
        //navigate to Competition teams
        coordinator?.openTeams(item, useCase)
    }
}
