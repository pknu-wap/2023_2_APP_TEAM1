//
//  PillSearchViewController.swift
//  dailyCare
//
//  Created by KimMinSeok on 11/27/23.
//

import UIKit
import Combine


class PillSearchViewController: UIViewController, XMLParserDelegate{
    
    //MARK: - 선언하는 부분
    var currentElement = ""                // 현재 Element
    @Published var pillItems = [[String : String]]() // 영화 item Dictional Array
    var pillItem = [String: String]()     // 영화 item Dictionary
    var entpName = ""
    @Published var itemName = ""
    
    var dataSource: [String] = ["iOS", "iOS 앱", "iOS 앱 개발", "iOS 앱 개발 알아가기", "iOS 앱 개발 알아가기 jake"]
    private var cancellables: Set<AnyCancellable> = []
    var filteredDataSource: [String] = []
    
    private let PILL_API_KEY = Bundle.main.object(forInfoDictionaryKey: "PILL_API_KEY") as? String
    func requestApiInfo(Url : String) {
        // OPEN API 주소
        // 1. URL 만들기
        guard let PILL_API_KEY = PILL_API_KEY else { return }
        // Your original API request code
        guard let itemName = Url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=\(PILL_API_KEY)&trustEntpName=%ED%95%9C%EB%AF%B8%EC%95%BD%ED%92%88(%EC%A3%BC)&itemName=\(itemName)") else { return }

        print(url)

        // 2. URLSession을 사용하여 데이터 로드
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // 3. 데이터를 가지고 작업 수행
                let xmlParser = XMLParser(data: data)
                // 이제 xmlParser를 사용하여 데이터를 파싱하고 필요한 작업을 수행할 수 있습니다.
                xmlParser.delegate = self;
                self.pillItems.removeAll() // 기존 데이터 초기화
                xmlParser.parse()
            }
        }.resume() // URLSession 작업 시작
    }

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
        requestApiInfo(Url : "")
        view.backgroundColor = .white
        
        $pillItems
            .sink { [weak self] itemNa in
                guard let self = self else { return }
                print("semail changed to: \(itemNa ?? [])")

                var concatenatedText = ""

                // Clear the dataSource array before adding new item names
                dataSource.removeAll()

                for i in itemNa {
                    if let itemName = i["itemName"]?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        concatenatedText += itemName + " "
                        print("Item Name: \(itemName)")
                        dataSource.append(itemName)
                    }
//                    print(dataSource)
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    // helloLabel.text = concatenatedText
                }
            }
            .store(in: &cancellables)

        
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
    // XMLParserDelegate 함수
        // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            pillItem = [String : String]()
            entpName = ""
            itemName = ""
        }
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            var newItem = [String: String]()
            newItem["entpName"] = entpName
            newItem["itemName"] = itemName

            pillItems.append(newItem)
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 현재 엘리먼트에 따라 변수에 누적
        if currentElement == "entpName" {
            entpName += string
        } else if currentElement == "itemName" {
            itemName += string
        }
    }
}

extension PillSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEditMode ? filteredDataSource.count : dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()  // 셀이 nil인 경우 빈 셀을 반환
        }

        if isEditMode, indexPath.row < filteredDataSource.count {
            cell.textLabel?.text = filteredDataSource[indexPath.row]
        } else if indexPath.row < dataSource.count {
            cell.textLabel?.text = dataSource[indexPath.row]
        } else {
            // 예외 처리 또는 기본 값 설정
            cell.textLabel?.text = "Out of Range"
        }

        return cell
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
//        filteredDataSource = dataSource.filter { $0.contains(text) }
//        tableView.reloadData()
        print("============",text)
        requestApiInfo(Url : text)
        $pillItems
            .sink { [weak self] itemNa in
                guard let self = self else { return }
//                print("semail changed to: \(itemNa ?? [])")
                print("=================================================")
                var concatenatedText = ""

                // Clear the dataSource array before adding new item names
                dataSource.removeAll()

                for i in itemNa {
                    if let itemName = i["itemName"]?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        concatenatedText += itemName + " "
//                        print("Item Name: \(itemName)")
                        dataSource.append(itemName)
                    }
                    print(dataSource)
                }

                DispatchQueue.main.async {
                    print("-------Hello")
                    self.tableView.reloadData()
                    // helloLabel.text = concatenatedText
                }
            }
            .store(in: &cancellables)
    }
}
