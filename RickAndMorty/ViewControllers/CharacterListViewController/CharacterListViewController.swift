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
    private var collectionView: UICollectionView!
    
    var imageCache: ImageCacheProtocol?
    var viewModel: CharacterListViewModelProtocol!

    private var dataSource: UICollectionViewDiffableDataSource<SectionItem, CharacterResponse>!
    private var dataObservation: AnyCancellable?
    private var errorObservation: AnyCancellable?
    
    private static let cellID = "CharacterCell"
    
    private var collectionLayout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100))
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        
        title = "Characters title".localized
        
        setupDataSource()
        setupCollectionView()
        bindView()
        
        viewModel.viewDidLoad()
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionItem, CharacterResponse>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            self?.cell(for: collectionView, indexPath: indexPath, item: itemIdentifier) ?? UICollectionViewCell()
        }
    }

    private func cell(for collectionView: UICollectionView, indexPath: IndexPath, item: CharacterResponse) -> CharacterCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellID, for: indexPath) as! CharacterCell
        
        cell.avatar = URLImageAsset(URL(string: item.image ?? ""), cache: imageCache)
        cell.status = item.status.rawValue.localizedCapitalized
        cell.title = item.name
        
        return cell
    }
    
    private func setupCollectionView() {
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: Self.cellID)
        collectionView.allowsSelection = false
        collectionView.delegate = self
        stackHolder.addArrangedSubview(collectionView)
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

extension CharacterListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
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
