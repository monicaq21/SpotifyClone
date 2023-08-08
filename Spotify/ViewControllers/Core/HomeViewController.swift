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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}

