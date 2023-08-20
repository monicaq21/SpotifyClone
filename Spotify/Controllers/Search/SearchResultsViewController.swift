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

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    private var sections = [SearchSection]()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell
        else { return UITableViewCell() }
        
        switch result {
        case .artist(let model):
            cell.configure(
                with: SearchResultDefaultTableViewCellViewModel(
                    title: model.name,
                    imageURL: nil
                )
            )
        case .album(let model):
            cell.configure(
                with: SearchResultDefaultTableViewCellViewModel(
                    title: model.name,
                    imageURL: URL(string: model.images.first?.url ?? "")
                )
            )
        case .playlist(let model):
            cell.configure(
                with: SearchResultDefaultTableViewCellViewModel(
                    title: model.name,
                    imageURL: URL(string: model.images.first?.url ?? "")
                )
            )
        case .track(let model):
            cell.configure(
                with: SearchResultDefaultTableViewCellViewModel(
                    title: model.name,
                    imageURL: nil
                )
            )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        delegate?.didTapResult(result)
    }
    
}
