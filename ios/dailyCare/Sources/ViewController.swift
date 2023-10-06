//
//  ViewController.swift
//  kakaologinUIkit
//
//  Created by 서성원 on 2023/10/02.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    
    // 로그인 앤 아웃 상태 표시 (사용x)
    lazy var KakaoLoginStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "로그인 여부 라벨"
        return label
    }()
    
    // 데일리 케어 아이콘
    lazy var mainIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "DailyCareLogo.png") // 이미지 이름을 설정하십시오
        imageView.image = image
        return imageView
    }()

    // id 입력창
    lazy var enterId : UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "id", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = placeholderText
        
        // 그림자 효과를 설정합니다.
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        textField.layer.shadowRadius = 2.0
        textField.layer.shadowOpacity = 0.5
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 비번 입력창
    lazy var enterPassword : UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = placeholderText
        
        // 그림자 효과를 설정합니다.
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        textField.layer.shadowRadius = 2.0
        textField.layer.shadowOpacity = 0.5
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // 카카오 로그인 버튼
    lazy var KakaoLoginButton = { (_ title: String, _ action: Selector) -> UIButton in
        let button = UIButton()
        let image = UIImage(named: "kakao.png")
        let imageSize2 = CGSize(width: 40, height: 40)
        button.setImage(image?.resize(targetSize: imageSize2), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // 카카오 로그아웃 버튼
    lazy var KakaoLogoutButton = { (_ title: String, _ action: Selector) -> UIButton in
        let button = UIButton()
        let image = UIImage(named: "logout.png")
        let imageSize = CGSize(width: 50, height: 50)
        button.setImage(image?.resize(targetSize: imageSize), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // 일반 로그인 버튼
    lazy var loginButtion = {
        let button = UIButton()
        let image = UIImage(named: "login.png")
        let imageSize2 = CGSize(width: 200, height: 200)
        button.setImage(image?.resize(targetSize: imageSize2), for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        // Auto Layout 설정
        button.translatesAutoresizingMaskIntoConstraints = false
            
        return button
    }()
    
    // 회원가입 버튼
    lazy var enterButton: UIButton = {
        let button = UIButton()
        
        // 버튼 텍스트 설정
        let buttonText = "회원가입"
        let attributedText = NSMutableAttributedString(string: buttonText)
        let range = NSRange(location: 0, length: buttonText.count)
        
        // 텍스트에 밑줄 추가
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        // 텍스트 색상 및 폰트 설정
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: range)
        
        // 속성이 적용된 텍스트를 버튼에 설정
        button.setAttributedTitle(attributedText, for: .normal)
        
        // 버튼 액션 설정 (아래의 #selector 내용은 적절한 액션으로 변경하세요)
        button.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        
        // Auto Layout 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    // 스택뷰 설정
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.spacing = 30
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var kakaoAuthVM: KakaoAuthM = { KakaoAuthM() } ()
    
    // 실행 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let kakaoLoginButton = KakaoLoginButton("카카오톡 로그인", #selector(loginButtonClicked))
        let kakaoLogoutButton = KakaoLogoutButton("로그아웃", #selector(logoutButtonClicked))
        
        
        stackView.addArrangedSubview(mainIcon)
        stackView.addArrangedSubview(enterId)
        stackView.addArrangedSubview(enterPassword)
        stackView.addArrangedSubview(kakaoLoginButton)
        stackView.addArrangedSubview(loginButtion)
        stackView.addArrangedSubview(enterButton)
        stackView.addArrangedSubview(kakaoLogoutButton)
        
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
        setBindings()
        
    } // VieDidLoad
    
    //MARK: - 버튼 액션 !!
    @objc func loginButtonClicked(){ // 카카오톡 로그인 버튼 클릭 시
        print("loginButtonClicked() called")
        kakaoAuthVM.KakaoLogin()
    }
    
    @objc func logoutButtonClicked(){ // 로그아웃 버튼 클릭 시
        print("logoutButtonClicked() called")
        kakaoAuthVM.kakaoLogout()
    }
    
    @objc func loginButtonTapped() {
        print("로그인 시도")
    }
    
    @objc func enterButtonTapped() {
        print("회원가입")
    }
} // viewcontroller

//MARK: - 뷰모델 바인딩
extension ViewController {
    fileprivate func setBindings() {
        self.kakaoAuthVM.loginStatusInfo
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: KakaoLoginStatusLabel)
            .store(in: &subscriptions)
    }
}

// 로그아웃 이미지 조절
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
}

// 캔버스 생성 -> editor에서 canvas
#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
}

struct ViewControllerPrePresentable_PreviewProvider : PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
    }
}
#endif
