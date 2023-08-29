//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        
        configureModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        sections.append(
            Section(title: "Profile", options: [
                Option(title: "View Your Profile", handler: { [weak self] in
                    DispatchQueue.main.async {
                        self?.viewProfile()
                    }
                })
            ])
        )
        
        sections.append(
            Section(title: "Account", options: [
                Option(title: "Sign Out", handler: { [weak self] in
                    DispatchQueue.main.async {
                        self?.signOutTapped()
                    }
                })
            ])
        )
    }
    
    private func viewProfile() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped() {
        AuthManager.shared.signOut { [weak self] signedOut in
            guard let self else { return }
            if signedOut {
                // show welcome screen
                DispatchQueue.main.async {
                    let welcomeVC = UINavigationController(rootViewController: WelcomeViewController())
                    welcomeVC.navigationBar.prefersLargeTitles = true
                    welcomeVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                    welcomeVC.modalPresentationStyle = .fullScreen
                    self.present(welcomeVC, animated: true) {
                        self.navigationController?.popToRootViewController(animated: false) // this pops all navigation VCs off the stack, so only the welcomeVC remains in the hierarchy.
                    }
                }
            }
        }
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // call handler for call
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    
}
