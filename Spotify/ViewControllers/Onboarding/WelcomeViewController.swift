//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private var signInButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
        view.backgroundColor = .systemGreen
        
        setupButtonUI()
        
        view.addSubview(signInButton)
        
        view.layoutIfNeeded()
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    func setupButtonUI() {
        signInButton.backgroundColor = .white
        signInButton.setTitle("Sign In with Spotify", for: .normal)
        signInButton.setTitleColor(.blue, for: .normal)
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 80 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
    }
    
    @objc func didTapSignIn() {
        let authVC = AuthViewController()
        
        // login completed
        authVC.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        authVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when singing in",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    

}
