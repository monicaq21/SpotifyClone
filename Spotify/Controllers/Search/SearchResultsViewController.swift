//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

class SearchResultsViewController: UIViewController {
    
    private var sections = [SearchSection]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Playlists", results: playlists)
        ]
        
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell
        else { return UITableViewCell() }
        
        switch result {
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .album(let model):
            cell.textLabel?.text = model.name
        case .playlist(let model):
            cell.textLabel?.text = model.name
        case .track(let model):
            cell.textLabel?.text = model.name
        }
        

        
//        cell.configure(with: result)
        
        return cell
    }
    
}
