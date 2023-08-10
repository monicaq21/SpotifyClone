//
//  ViewController.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        
        fetchData()
        
    }
    
    private func fetchData() {
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                
                let genres = model.genres
                var seeds = Set<String>() // randomly pick 5 genres to feed into recommendations
                while seeds.count < 5 {
                    if let randomGenre = genres.randomElement() {
                        seeds.insert(randomGenre)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds, completion: { result in
                    print(result)
                })
                
            case .failure(let error):
                break
            }
        }
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}

