//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit
import Combine

class CharacterListViewController: BaseViewController {
    private struct SectionItem: Hashable {}
    private var tableView = UITableView()
    
    var imageCache: ImageCacheProtocol?
    var viewModel: CharacterListViewModelProtocol!

    private var dataSource: UITableViewDiffableDataSource<SectionItem, CharacterResponse>!
    private var dataObservation: AnyCancellable?
    private var errorObservation: AnyCancellable?
    
    private static let cellID = "CharacterCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters title".localized
        
        setupDataSource()
        setupTableView()
        bindView()
        
        viewModel.viewDidLoad()
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<SectionItem, CharacterResponse>(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            self?.cell(for: tableView, indexPath: indexPath, item: itemIdentifier) ?? UITableViewCell()
        }
    }

    private func cell(for tableView: UITableView, indexPath: IndexPath, item: CharacterResponse) -> CharacterCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath) as! CharacterCell
        
        cell.avatar = URLImageAsset(URL(string: item.image ?? ""), cache: imageCache)
        cell.status = item.status.rawValue.localizedCapitalized
        cell.title = item.name
        
        return cell
    }
    
    private func setupTableView() {
        tableView.register(CharacterCell.self, forCellReuseIdentifier: Self.cellID)
        tableView.allowsSelection = false
        tableView.delegate = self
        stackHolder.addArrangedSubview(tableView)
    }
    
    private func bindView() {
        dataObservation = viewModel.output.$items
            .map({ $0.snapshot(for: SectionItem()) })
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.dataSource.apply(items)
            }
        
        errorObservation = viewModel.output.error
            .subscribe(on: DispatchQueue.main)
            .sink {
                ToastMessage.showError(message: $0)
            }
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            viewModel.viewDidRequestForNextPage()
        }
    }
}

extension Array where Element: Hashable {
    func snapshot<Section: Hashable>(for section: Section) -> NSDiffableDataSourceSnapshot<Section, Element> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Element>()
        snapshot.appendSections([section])
        snapshot.appendItems(self)
        return snapshot
    }
}
