//
//  MainCoordinator.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 12/09/2023.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        let vc = Configurators.leagues(coordinator: self).getViewController()
        vc.title = "Football Leagues"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openTeams(_ item: LeaguesUIModel.CompetitionUIModel,_ useCase: LeaguesUseCase){
        let vc = Configurators.teams(coordinator: self, useCase, item).getViewController()
        vc.title = item.name
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openTeamGames(item: TeamsUIModel.TeamUIModel){
        let vc = Configurators.teamDetails(item: item, coordinator: self).getViewController()
        vc.title = item.name
        navigationController.pushViewController(vc, animated: true)
    }

    func childDidFinish(_ child: Coordinator?){
        for (index,coordinator) in childCoordinators.enumerated(){
            if coordinator === child{
                childCoordinators.remove(at: index)
                break;
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {return}
//
//        if navigationController.viewControllers.contains(fromViewController){
//            return
//        }
//        if let teamsViewController = fromViewController as? TeamsViewController{
//            childDidFinish(teamsViewController.viewModel.coordinator)
//        }
//
//        if let teamsDetails = fromViewController as? TeamDetailsViewController{
//            childDidFinish(teamsDetails.coordinator)
//        }
//    }
}
