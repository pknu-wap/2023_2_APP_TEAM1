//
//  MyPageViewController.swift
//  dailyCare
//

import Foundation
import UIKit
import SnapKit
import Combine

class MyPageViewController: UIViewController {
    
//    @Published var semail: String?    // 데이터를 전달받아 저장할 변수
    @Published var semail: [String] = []    // 데이터를 전달받아 저장할 변수
    
    // 스택 뷰 만들기
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 0
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    var buttonConfig = UIButton.Configuration.plain()
    
    lazy var titleAttribute : AttributeContainer = {
        var titleAttribute = AttributeContainer()
        titleAttribute.font = UIFont.systemFont(ofSize: 20)
        titleAttribute.foregroundColor = UIColor.black
        return titleAttribute
    }()
    
    
    //  내 진료기록 모아보기
    lazy var userRecord : UIButton = {
        
        let button = UIButton(configuration: buttonConfig)
        let img = UIImage(named: "userRecord")
        button.setImage(img, for: .normal)
        button.configuration?.attributedTitle = AttributedString("내 진료기록 모아보기", attributes: titleAttribute)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 19, leading: 42, bottom: 19, trailing: 147)
        button.configuration?.imagePlacement = .leading
        button.configuration?.imagePadding = 10
        return button
    }()
    
    // 회원정보 수정
    lazy var userProfileEdit : UIButton = {
        let button = UIButton(configuration: buttonConfig)
        let img = UIImage(named: "userProfileEdit")
        button.setImage(img, for: .normal)
        button.configuration?.attributedTitle = AttributedString("회원정보 수정", attributes: titleAttribute)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 19, leading: 42, bottom: 19, trailing: 206)
        button.configuration?.imagePlacement = .leading
        button.configuration?.imagePadding = 10
        return button
    }()
    
    // 정보수정 요청
    lazy var bugReport : UIButton = {
        let button = UIButton(configuration: buttonConfig)
        let img = UIImage(named: "bugReport")
        button.setImage(img, for: .normal)
        button.configuration?.attributedTitle = AttributedString("정보수정 요청", attributes: titleAttribute)
        button.setTitleColor(.black, for: .normal)
        button.configuration?.imagePadding = 10
        button.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 19, leading: 42, bottom: 19, trailing: 206)
        button.configuration?.imagePlacement = .leading
        return button
    }()
    
    // 유저 프로필 뷰
    lazy var userImageView : UIImageView =  {
        //let userImage = kakaoAuthManager?.userNickname
        var view = UIImageView()
        if let imageUrl = URL(string: self.semail[2]) {
                    URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                view.image = image
                            }
                        }
                    }.resume()
                }
        return view
    }()
    
    // 유저 닉네임
    lazy var userName : UILabel = {
        var label = UILabel()
        label.text = semail[1]
        label.textColor = .black
        return label
    }()
    
    // 유저 이메일
    lazy var userEmail : UILabel = {
        var label = UILabel()
        label.text = semail[0]
        label.textColor = .black
        label.numberOfLines = 0 // 0으로 설정하면 텍스트 크기에 따라 여러 줄로 표시됩니다.
        label.adjustsFontSizeToFitWidth = true // 텍스트 크기에 맞게 자동으로 크기를 조절합니다.
        label.minimumScaleFactor = 0.5 // 최소 축소 비율을 설정할 수 있습니다.
        return label
    }()
    
    // 유저 프로필 수정
    lazy var userProfileButton : UIButton =  {
        let button = UIButton()
        let img = UIImage(named: "setting.png")
        button.setImage(img, for: .normal)
        return button
    }()
    // KakaoAuthM 인스턴스를 저장하기 위한 프로퍼티
    //var kakaoAuthManager: KakaoAuthM?
    
    // 유저 프로필 뷰
    lazy var userProfileView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 구별선 설정
        let border1 = CALayer();
        border1.backgroundColor = UIColor.black.cgColor
        border1.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height:1)
        
        let border2 = CALayer();
        border2.backgroundColor = UIColor.black.cgColor
        border2.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height:1)
        
        let border3 = CALayer();
        border3.backgroundColor = UIColor.black.cgColor
        border3.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height:1)

        let border4 = CALayer();
        border4.backgroundColor = UIColor.black.cgColor
        border4.frame = CGRect(x: 0,y: 60, width: self.view.frame.width, height:1)
        
        self.view.backgroundColor = .white
        self.title = "마이페이지"
        
        stackView.addArrangedSubview(userRecord)
        stackView.addArrangedSubview(userProfileEdit)
        stackView.addArrangedSubview(bugReport)
        
        self.view.addSubview(userImageView)
        self.view.addSubview(userName)
        self.view.addSubview(userEmail)
        self.view.addSubview(stackView)
        
        userImageView.snp.makeConstraints {
            make in make.top.equalTo(self.view.snp.top).offset(156.5)
            make.width.equalTo(52)
            make.height.equalTo(41)
            make.leftMargin.equalTo(44.5)
        }
        userName.snp.makeConstraints {
            make in make.top.equalTo(userImageView)
            make.width.equalTo(101)
            make.height.equalTo(19)
            make.left.equalTo(userImageView.snp.right).offset(30)
        }
        userEmail.snp.makeConstraints {
            make in make.bottom.equalTo(userImageView.snp.bottom)
            make.width.equalTo(101)
            make.height.equalTo(19)
            make.left.equalTo(userName.snp.left)
        }
        stackView.snp.makeConstraints {
            make in make.top.equalTo(userImageView.snp.bottom).offset(55)
            make.width.equalTo(self.view.snp.width)
            userRecord.snp.makeConstraints{
                make in make.height.equalTo(60)

            }
            userProfileEdit.snp.makeConstraints {
                make in make.height.equalTo(60)
                
            }
            bugReport.snp.makeConstraints {
                make in make.height.equalTo(60)
                
            }
            
        }
        userRecord.layer.addSublayer(border1)
        userProfileEdit.layer.addSublayer(border2)
        bugReport.layer.addSublayer(border3)
        bugReport.layer.addSublayer(border4)
        
        }
    }

