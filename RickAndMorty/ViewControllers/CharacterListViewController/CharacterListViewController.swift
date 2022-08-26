//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class CharacterListViewController: BaseViewController {
    var tableView = UITableView()
    
    var imageCache: ImageCacheProtocol?
    var viewModel: CharacterListViewModelProtocol

    init(viewModel: CharacterListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    private static let cellID = "CharacterCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters title".localized
        
        setupTableView()
        bindView()
        
        Task {
            await viewModel.viewDidLoad()
        }
    }
    
    private func setupTableView() {
        tableView.register(CharacterCell.self, forCellReuseIdentifier: Self.cellID)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        stackHolder.addArrangedSubview(tableView)
    }
    
    private func bindView() {
        viewModel.output.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &bag)

        viewModel.output.error
            .sink { [weak self] message in
                self?.showMessage(for: message)
            }
            .store(in: &bag)
    }
}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.output.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath) as! CharacterCell
        
        cell.avatar = URLImageAsset(URL(string: item.image ?? ""), cache: imageCache)
        cell.title = item.name
        cell.status = item.status.rawValue.localizedCapitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        Task {
            let indexPath = IndexPath(row: viewModel.output.items.count - 1, section: 0)
            if indexPaths.contains(indexPath) {
                await viewModel.viewDidRequestForNextPage()
            }
        }
    }
}
