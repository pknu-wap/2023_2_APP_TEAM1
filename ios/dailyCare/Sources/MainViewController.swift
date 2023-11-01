//
//  Mypage.swift
//  dailyCare
//
//  Created by 서성원 on 2023/10/09.
//

import Foundation
import UIKit
import SnapKit
import Combine


class MainViewController: UIViewController {
    
    var kakaoAuthManager: KakaoAuthM?  // KakaoAuthM 인스턴스를 저장하기 위한 프로퍼티
    
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

        // 그라데이션 레이어를 뷰의 레이어로 추가
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        // "Hello, World!" 레이블 추가
        let helloLabel = UILabel()
        helloLabel.text = "Hello, World!"
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

