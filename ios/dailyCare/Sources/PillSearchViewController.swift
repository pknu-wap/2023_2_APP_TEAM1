//
//  PillSearchViewController.swift
//  dailyCare
//
//  Created by KimMinSeok on 11/27/23.
//

import UIKit
import Combine

class PillSearchViewController: UIViewController {
    
    var kakaoAuthManager: KakaoAuthM?  // KakaoAuthM 인스턴스를 저장하기
    var ApiParser: ApiParser?
    
    private let searchBar: UISearchBar = {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search..."
            searchBar.backgroundColor = .secondarySystemBackground
            return searchBar
        }()
        private let dimmedView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.isHidden = true
            view.alpha = 0
            return view
        }()
        private var collectionView: UICollectionView?
        private let viewModel = mediPageViewController()
        private var cancellables = Set<AnyCancellable>()

        override func viewDidLoad() {
            super.viewDidLoad()
            setUI()
//            bind()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            collectionView?.frame = view.bounds
            dimmedView.frame = view.bounds
        }
        
        private func setUI() {
            view.backgroundColor = .systemBackground
            navigationController?.navigationBar.topItem?.titleView = searchBar
            setCollectionView()
            setSearchBar()
            view.addSubview(dimmedView)
        }
        
        private func bind() {
            viewModel
                .exploreModel
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.collectionView?.reloadData()
                }
                .store(in: &cancellables)
        }
        
        private func setSearchBar() {
            searchBar.delegate = self
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonDidTap))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }
        
        private func setCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            layout.itemSize = CGSize(width: (view.width - 4) / 3, height: (view.width - 4) / 3)
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 1
//            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            collectionView?.delegate = self
//            collectionView?.dataSource = self
//            collectionView?.register(mediPageViewController.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
            guard let collectionView = collectionView else { return }
            view.addSubview(collectionView)
        }
    }

    extension PillSearchViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard
                let text = searchBar.text,
                !text.replacingOccurrences(of: " ", with: "").isEmpty else {
                cancelButtonDidTap()
                return
            }
//            viewModel.addMockData()
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonDidTap))
            dimmedView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.dimmedView.alpha = 0.4
            }
        }
        
        @objc private func cancelButtonDidTap() {
            searchBar.resignFirstResponder()
            navigationItem.rightBarButtonItem = nil
            UIView.animate(withDuration: 0.2, animations: {
                self.dimmedView.alpha = 0
            }) { done in
                if done {
                    self.dimmedView.isHidden = true
                }
            }
            view.endEditing(true)
        }

}
