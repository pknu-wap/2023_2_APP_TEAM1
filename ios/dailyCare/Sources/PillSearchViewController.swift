//
//  PillSearchViewController.swift
//  dailyCare
//
//  Created by KimMinSeok on 11/27/23.
//

import UIKit
import Combine


class PillSearchViewController: UIViewController {
    
    
    var dataSource: [String] = ["iOS", "iOS 앱", "iOS 앱 개발", "iOS 앱 개발 알아가기", "iOS 앱 개발 알아가기 jake"]
    var filteredDataSource: [String] = []

    var isEditMode: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = nil

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        setupSearchController()
    }

    private func setupSearchController() {

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색(placeholder)"
        // 내비게이션 바는 항상 표출되도록 설정
        searchController.hidesNavigationBarDuringPresentation = false
        /// updateSearchResults(for:) 델리게이트를 사용을 위한 델리게이트 할당
        searchController.searchResultsUpdater = self
        /// 뒷배경이 흐려지지 않도록 설정
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension PillSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEditMode ? filteredDataSource.count : dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = isEditMode ? filteredDataSource[indexPath.row] : dataSource[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(isEditing ? filteredDataSource[indexPath.row] : dataSource[indexPath.row])
    }
}

extension PillSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredDataSource = dataSource.filter { $0.contains(text) }
        tableView.reloadData()
    }
}
