//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class CharacterListViewController: BaseViewController {
    private var tableView = UITableView()
    
    var imageCache: ImageCacheProtocol?
    var viewModel: CharacterListViewModelProtocol!
    
    private static let cellID = "CharacterCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindView()
        
        viewModel.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.register(CharacterCell.self, forCellReuseIdentifier: Self.cellID)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        stackHolder.addArrangedSubview(tableView)
    }
    
    private func bindView() {
        viewModel.items.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.store(in: &bag)
    }
}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath) as! CharacterCell
        
        cell.avatar = URLImageAsset(URL(string: item.image ?? ""), cache: imageCache)
        cell.title = item.name
        cell.status = item.status.rawValue.localizedCapitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            viewModel.viewDidRequestForNextPage()
        }
    }
}
