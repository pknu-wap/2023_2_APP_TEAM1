//
//  ApiParser.swift
//  dailyCare
//
//  Created by KimMinSeok on 11/15/23.
//

import Foundation
import UIKit
import SnapKit
import Combine

class ApiParser : NSObject, ObservableObject, XMLParserDelegate {
    
    var xmlParser = XMLParser()
    
    //MARK: - 선언하는 부분
    var currentElement = ""                // 현재 Element
    @Published var pillItems = [[String : String]]() // 영화 item Dictional Array
    @Published var pillItem = [String: String]()     // 영화 item Dictionary
    var entpName = ""
    var itemName = "활명수"
    var itemSeq = ""
    var efcyQesitm = ""
    var useMethodQesitm = ""
    
    private let PILL_API_KEY = Bundle.main.object(forInfoDictionaryKey: "PILL_API_KEY") as? String
    
    func requestApiInfo() {
        
        guard let PILL_API_KEY = PILL_API_KEY else { return }
        // OPEN API 주소
        // 1. URL 만들기
        guard let url = URL(string: "https://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=\(PILL_API_KEY)&trustEntpName=%ED%95%9C%EB%AF%B8%EC%95%BD%ED%92%88(%EC%A3%BC)&pageNo=1&startPage=1&numOfRows=1") else { return }

        // 2. URLSession을 사용하여 데이터 로드
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // 3. 데이터를 가지고 작업 수행
                let xmlParser = XMLParser(data: data)
                // 이제 xmlParser를 사용하여 데이터를 파싱하고 필요한 작업을 수행할 수 있습니다.
                xmlParser.parse()
                print("TestHello")
            }
        }.resume() // URLSession 작업 시작
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
        print("------2-------",entpName,pillItem["entpName"],pillItems)
    }

}
