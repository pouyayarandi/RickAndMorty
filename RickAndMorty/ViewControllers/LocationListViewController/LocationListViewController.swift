//
//  LocationListViewController.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class LocationListViewController: BaseViewController {
    private var tableView = UITableView()
    
    var viewModel: LocationListViewModelProtocol
    
    init(viewModel: LocationListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    private static let cellID = "LocationCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Locations title".localized
        
        setupTableView()
        bindView()
        
        viewModel.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.register(GenericCell.self, forCellReuseIdentifier: Self.cellID)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        stackHolder.addArrangedSubview(tableView)
    }
    
    private func bindView() {
        viewModel.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &bag)
        
        viewModel.error
            .sink { [weak self] message in
                self?.showMessage(for: message)
            }
            .store(in: &bag)
    }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath) as! GenericCell
        
        cell.title = item.name
        cell.subtitle = "\(item.type) - \(item.dimension)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexPath = IndexPath(row: viewModel.items.value.count - 1, section: 0)
        if indexPaths.contains(indexPath) {
            viewModel.viewDidRequestForNextPage()
        }
    }
}
