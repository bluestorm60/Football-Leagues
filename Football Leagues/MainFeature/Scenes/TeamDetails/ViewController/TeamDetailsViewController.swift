//
//  TeamDetailsViewController.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 12/09/2023.
//

import UIKit

class TeamDetailsViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deInit : \(String(describing: Self.self))")
    }
    
    init(_ coordinator: MainCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
