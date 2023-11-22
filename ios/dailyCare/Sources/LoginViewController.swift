//
//  ViewController.swift
//  Login
//

import UIKit
import SnapKit
import Combine
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {

    var subscriptions = Set<AnyCancellable>()
    
    // 로그인 앤 아웃 상태 표시 (사용x)
    lazy var KakaoLoginStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "로그인 여부 라벨"
        return label
    }()
    
    // MARK: - UI 선언들
    // 데일리 케어 아이콘
    lazy var mainIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "DailyCareLogo.png") // 이미지 이름을 설정하십시오
        imageView.image = image
        return imageView
    }()
    
    // 카카오 로그인 버튼
    lazy var KakaoLoginButton = { (_ title: String, _ action: Selector) -> UIButton in
        let button = UIButton()
        let image = UIImage(named: "kakao.png")
        let imageSize2 = CGSize(width: 200, height: 50)
        button.setImage(image?.resize(targetSize: imageSize2), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // 구글 로그인 버튼
    lazy var GoogleLoginButton = { (_ title: String, _ action: Selector) -> UIButton in
        let button = UIButton()
        let image = UIImage(named: "google.png") // 구글 로그인 버튼 이미지 이름을 설정하십시오
        let imageSize = CGSize(width: 200, height: 50) // 이미지 크기를 조정하십시오
        button.setImage(image?.resize(targetSize: imageSize), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
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
    lazy var GoogleAuthVM: GoogleAuthM = { GoogleAuthM() } ()

    //MARK: - 실행 부분(viewDidLoad)
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
        
        let kakaoLoginButton = KakaoLoginButton("카카오톡 로그인", #selector(kakaoLoginButtonClicked))
        let googleLoginButton = GoogleLoginButton("구글 로그인", #selector(googleLoginButtonClicked))
        
        stackView.addArrangedSubview(mainIcon)
        stackView.addArrangedSubview(googleLoginButton)
        stackView.addArrangedSubview(kakaoLoginButton)
        
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
        setBindings()
        
    } // VieDidLoad

    
    //MARK: - 버튼 액션 !!
    @objc func kakaoLoginButtonClicked(){ // 카카오톡 로그인 버튼 클릭 시
        print("kakaoLoginButtonClicked() called")
        Task {
            if await kakaoAuthVM.kakaoLoginWithAccount() {
                // 로그인 성공한 경우 MainViewController로 화면 전환
                let mainViewController = TestViewController()
                mainViewController.setEmail(kakaoAuthVM.userEmail ?? "N/A")
                print("hello : \(kakaoAuthVM.userNickname)")
                // 숨기기 위해 뒤로가기 버튼을 nil로 설정
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

                self.navigationController?.pushViewController(mainViewController, animated: true)
            }
        }
    }
    
    @objc func googleLoginButtonClicked() async {
        print("googleLoginButtonClicked() called")
        /*
        Task {
            if GoogleAuthVM.GoogleSignIn(withPresenting: self) {
                // 로그인 성공한 경우 MainViewController로 화면 전환
                let mainViewController = MainViewController()
                mainViewController.setEmail(GoogleAuthVM.userEmail ?? "N/A")
                self.navigationController?.pushViewController(mainViewController, animated: true)
            }
        }
         */
        GoogleAuthVM.GoogleSignIn(withPresenting: self) // 생성한 인스턴스를 통해 메서드 호출
        
    }

    // 로그아웃 버튼 클릭
    @objc func logoutButtonClicked(){
        print("logoutButtonClicked() called")
        kakaoAuthVM.kakaoLogout()
    }
    
    @objc func loginButtonTapped() {
        let mainViewController = MainViewController()
        self.navigationController?.pushViewController(mainViewController, animated: true)
        
        print("로그인 시도")
    }
    
    @objc func enterButtonTapped() {
        print("회원가입")
    }
} // viewcontroller

//MARK: - 뷰모델 바인딩
extension LoginViewController {
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
        LoginViewController()
    }
}

struct ViewControllerPrePresentable_PreviewProvider : PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
    }
}
#endif
