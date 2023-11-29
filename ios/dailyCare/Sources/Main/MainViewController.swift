//
//  ViewController.swift
//  CarouselView
//
//  Created by 김종권 on 2021/07/19.
//

import UIKit
import Combine

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
            super.init(nibName: nil, bundle: nil)
            // Additional setup if needed
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    var kakaoAuthManager: KakaoAuthM?  // KakaoAuthM 인스턴스를 저장하기 위한 프로퍼티
    
    // 질병 선택 창
    lazy var illSelector: UIPickerView = {
        
            let picker = UIPickerView()
        
            picker.frame = CGRect(x: 270, y: 270, width: 80.0, height: 50.0)
            picker.backgroundColor = .white
            picker.delegate = self
            picker.dataSource = self
            return picker
    }()

    private let values: [String] = ["당뇨","감기","비염"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(values[row])")
    }
            
    func MainViewController() { // 메인 이미지
        let testImageView = UIImageView()
        if let image = UIImage(named: "main.png") {
            testImageView.image = image
            testImageView.contentMode = .scaleAspectFill
            testImageView.clipsToBounds = true
            testImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(testImageView)
            
            // 아래의 safeArea 제약을 비활성화하고, 뷰의 가장 위쪽에 이미지 뷰를 배치
            let topConstraint = testImageView.topAnchor.constraint(equalTo: view.topAnchor)
            let leadingConstraint = testImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailingConstraint = testImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let heightConstraint = testImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3) // 이미지 크기를 높이의 25%로 설정
            
            topConstraint.isActive = true
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true
            heightConstraint.isActive = true
        } else {
            print("Image not found")
        }
    }
    
    func userName(_ email: String) { // 사용자 이름
        
            let userLabel = UILabel()
            userLabel.text = "\(email)"
            userLabel.translatesAutoresizingMaskIntoConstraints = false
            userLabel.font = .italicSystemFont(ofSize: 20)
            userLabel.textColor = .black
            userLabel.textAlignment = .center
            
            view.addSubview(userLabel)
            
            let safeArea = view.safeAreaLayoutGuide
            let leadingConstraint = userLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 60)
            let topConstraint = userLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 220)

            leadingConstraint.isActive = true
            topConstraint.isActive = true
            
            userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        }
    func caution() { // 주의사항
            let testLabel = UILabel()
            testLabel.text = "주의사항"
            testLabel.translatesAutoresizingMaskIntoConstraints = false
            testLabel.font = .italicSystemFont(ofSize: 20)
            testLabel.textColor = .black
            testLabel.textAlignment = .center
            
            view.addSubview(testLabel)
            
            let safeArea = view.safeAreaLayoutGuide
            let leadingConstraint = testLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 60)
            let topConstraint = testLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 260)

            leadingConstraint.isActive = true
            topConstraint.isActive = true
            
            testLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    
    func checkList() {
            let testLabel = UILabel()
            testLabel.text = "체크리스트"
            testLabel.translatesAutoresizingMaskIntoConstraints = false
            testLabel.font = .italicSystemFont(ofSize: 20)
            testLabel.textColor = .black
            testLabel.textAlignment = .center
            
            view.addSubview(testLabel)
            
            let safeArea = view.safeAreaLayoutGuide
            let leadingConstraint = testLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 60)
            let topConstraint = testLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 430)

            leadingConstraint.isActive = true
            topConstraint.isActive = true
            
            testLabel.translatesAutoresizingMaskIntoConstraints = false
        }

    var CautionSource: [String] = [] {
            didSet {
                // Reload or update your collection view when CautionSource is updated
                cautionView.reloadData()
            }
        }
    var CheckSource : [String] = []

    lazy var cautionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 30
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
        return view
    }()

    lazy var checkListView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 30
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.hidesBackButton = true
        
        
        view.backgroundColor = .white
        
//        if let userEmail = kakaoAuthManager?.userEmail {
//            userName(userEmail)
//         }
        if let userNicname = kakaoAuthManager?.userNickname {
            userName(userNicname)
         }

        MainViewController()
        caution()
        checkList()

        setupDataSource()
        addSubviews()
        setupDelegate()
        registerCell()
        cautionWindowSize()
        
        SharedData.shared.$userInfo
                    .sink { [weak self] userInfo in
                        guard let self = self else { return }
                        // Handle updated userInfo here
                        print("main updated userInfo: \(userInfo)")

                        // Assuming userInfo is an array of strings
                        self.CautionSource = userInfo
                    }
                    .store(in: &cancellables)
        
        
        CheckSource = ["Check 1", "Check 2", "Check 3", "Check 4"]
        
        
        cautionView.translatesAutoresizingMaskIntoConstraints = false
        checkListView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.illSelector)
        
    }
    
    func setEmail(_ email: String) {
        print("main email : ",email)
    }
    func setNickname(_ Nickname: String) {
        print("main Nickname : ",Nickname)
        userName(Nickname)
    }
    
    private func setupDataSource() {
        for i in 1...4 {
            CautionSource += ["\(i)"]
        }
        for j in 1...4{
            CheckSource += ["\(j)"]
        }
    }

    private func addSubviews() {
            // 컨테이너 뷰 생성
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(container)
            
            // 컨테이너 뷰에 컬렉션 뷰들을 추가
            container.addSubview(cautionView)
            container.addSubview(checkListView)
            
            // 컨테이너 뷰 내에서 각 컬렉션 뷰의 배치 및 크기 설정
            container.snp.makeConstraints { make in
                make.center.equalToSuperview() // 화면 중앙 정렬
                make.leading.equalToSuperview().offset(20) // 왼쪽 여백 20 포인트
                make.trailing.equalToSuperview().offset(-20) // 오른쪽 여백 20 포인트
            
                make.height.equalTo(520) // 두 개의 컬렉션 뷰와 간격의 합
            }
        
            let separatorView = UIView() // 컨테이너 사이 구분선 설정
                separatorView.backgroundColor = .lightGray
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(separatorView)
                
                separatorView.snp.makeConstraints { make in
                    make.top.equalTo(cautionView.snp.bottom).offset(5) // 컬렉션 뷰 간의 간격을 설정
                    make.leading.equalToSuperview().offset(30) // 왼쪽 여백 30 포인트 (원하는 여백 설정)
                    make.trailing.equalToSuperview().offset(-30) // 오른쪽 여백 30 포인트 (원하는 여백 설정)
                    make.height.equalTo(1) // 구분선의 높이
                }
                
                checkListView.snp.makeConstraints { make in
                    make.top.equalTo(cautionView.snp.bottom).offset(50) // 컬렉션 뷰 간의 간격을 설정
                    make.leading.equalToSuperview().offset(30) // 왼쪽 여백 20 포인트
                    make.trailing.equalToSuperview().offset(-30) // 오른쪽 여백 20 포인트
                    make.height.equalTo(150)
                }
        }

    private func setupDelegate() {
        cautionView.delegate = self
        cautionView.dataSource = self
        checkListView.delegate = self
        checkListView.dataSource = self
    }

    private func registerCell() {
        cautionView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
        checkListView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
    }

    private func cautionWindowSize() { // 주의사항 윈도우 크기 설정
        cautionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(30) // 왼쪽 여백 20 포인트
            make.trailing.equalToSuperview().offset(-30) // 오른쪽 여백 20 포인트
            make.height.equalTo(150)
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cautionView {
            return CautionSource.count
        } else if collectionView == checkListView {
            return CheckSource.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath)
        if let cell = cell as? MyCell {
            if collectionView == cautionView {
                cell.model = CautionSource[indexPath.item]
            } else if collectionView == checkListView {
                cell.model = CheckSource[indexPath.item]
            }
        }

        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 60 // 여백을 뺀 너비 (양쪽에 각각 20 포인트의 여백)
        let cellHeight = collectionView.frame.height - 30
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
