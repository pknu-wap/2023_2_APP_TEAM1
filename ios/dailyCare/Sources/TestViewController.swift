//
//  Mypage.swift
//  dailyCare
//

import Foundation
import UIKit
import SnapKit
import Combine

struct tagType {
    let item: [item]
}

struct item {
    var entpName: String
    var itemName: String
    var itemSeq: String
    var efcyQesitm: String
    var useMethodQesitm: String
    var atpnWarnQesitm: String
    var atpnQesitm: String
    var intrcQesitm: String
    var seQesitm: String
    var depositMethodQesitm: String
    var openDe: String
    var updateDe: String
    var itemImage: String
    var bizrno: String
}

class TestViewController: UIViewController, XMLParserDelegate {
    
    var kakaoAuthManager: KakaoAuthM?  // KakaoAuthM 인스턴스를 저장하기 위한 프로퍼티
    
    
    var xmlParser = XMLParser()
    
    //MARK: - 선언하는 부분
    var currentElement = ""                // 현재 Element
    var pillItems = [[String : String]]() // 영화 item Dictional Array
    var pillItem = [String: String]()     // 영화 item Dictionary
    var entpName = ""
    var itemName = ""
    var itemSeq = ""
    var efcyQesitm = ""
    var useMethodQesitm = ""
    
    private let PILL_API_KEY = Bundle.main.object(forInfoDictionaryKey: "PILL_API_KEY") as? String
    func requestApiInfo() {
        // OPEN API 주소
        // 1. URL 만들기
        guard let PILL_API_KEY = PILL_API_KEY else { return }
        guard let url = URL(string: "https://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=\(PILL_API_KEY)&trustEntpName=%ED%95%9C%EB%AF%B8%EC%95%BD%ED%92%88(%EC%A3%BC)&pageNo=1&startPage=1&numOfRows=1") else { return }
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
                xmlParser.parse()
            }
        }.resume() // URLSession 작업 시작
    }
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var main: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "main.png") // 이미지 이름을 설정하십시오
        imageView.image = image
        return imageView
    }()

    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.spacing = 30
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    lazy var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.isPagingEnabled = true
            return scrollView
        }()
    
    override func viewDidLoad() {
        requestApiInfo()
        super.viewDidLoad()
        
        if let userEmail = kakaoAuthManager?.userEmail {
             setEmail(userEmail)
         }
        // 그라데이션 색상 설정
        let startColor = UIColor(red: 0.63, green: 0.91, blue: 0.56, alpha: 1.0).cgColor
        
        let endColor = UIColor(red: 0.63, green: 0.86, blue: 0.8, alpha: 1.0).cgColor
        
        // 그라데이션 레이어 생성
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        // 그라데이션 색상 배열 설정
        gradientLayer.colors = [startColor, endColor]
        // 그라데이션 시작점 및 종료점 설정
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 중간상단
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 중간하단
        
        print("------1-------",entpName)
        // 그라데이션 레이어를 뷰의 레이어로 추가
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        // "Hello, World!" 레이블 추가
        let helloLabel = UILabel()
        helloLabel.text = entpName
        helloLabel.textColor = UIColor.white // 텍스트 색상 설정
        helloLabel.font = UIFont.systemFont(ofSize: 24) // 텍스트 폰트 및 크기 설정
        helloLabel.textAlignment = .center // 텍스트 정렬 설정
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 스택뷰에 "Hello, World!" 레이블 추가
        stackView.addArrangedSubview(helloLabel)
        stackView.addArrangedSubview(main)
        stackView.addArrangedSubview(scrollView)
        stackView.addArrangedSubview(emailLabel)
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            
        }
            }
    
    @objc func Tapped() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func setEmail(_ email: String) {
        print("main email : ",email)
        emailLabel.text = "이메일: \(email)"
    }
    
    // XMLParserDelegate 함수
        // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            pillItem = [String : String]()
            entpName = ""
            itemName = ""
            itemSeq = ""
            efcyQesitm = ""
            useMethodQesitm = ""
        }
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            pillItem["entpName"] = entpName;
            pillItem["itemName"] = itemName;
            pillItem["itemSeq"] = itemSeq;
            pillItem["efcyQesitm"] = efcyQesitm;
            pillItem["useMethodQesitm"] = useMethodQesitm;
            
            pillItems.append(pillItem)
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 현재 엘리먼트에 따라 변수에 누적
        if currentElement == "entpName" {
            entpName += string
        } else if currentElement == "itemName" {
            itemName += string
        } else if currentElement == "itemSeq" {
            itemSeq += string
        } else if currentElement == "efcyQesitm" {
            efcyQesitm += string
        } else if currentElement == "useMethodQesitm" {
            useMethodQesitm += string
        }        // UI 업데이트를 메인 스레드에서 처리
        print("------2-------",entpName)
        print("------3------", pillItem["entpName"])
        print("-----------", pillItems)
    }
    
}


#if DEBUG

import SwiftUI

struct ViewControllerPresentable2: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        MainViewController()
    }
}

struct ViewControllerPrePresentable_PreviewProvider2 : PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
    }
}
#endif

