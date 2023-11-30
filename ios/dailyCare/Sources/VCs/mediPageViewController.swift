//
//  mediPageViewController.swift
//  dailyCare
//

import Foundation
import UIKit
import SnapKit
import Combine

class mediPageViewController: UIViewController {
    
    // 주의사항 뷰
    lazy var CautionView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.frame = CGRect(x: 0, y: 0, width: 327, height: 116)
        var titleLabel = UILabel()
        titleLabel.text = "주의사항"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        var textLabel = UILabel()
        textLabel.text = "텍스트"
        view.addSubview(titleLabel)
        view.addSubview(textLabel)
        
        titleLabel.snp.makeConstraints {
            make in make.top.equalTo(view.snp.top).offset(17)
            make.left.equalTo(22)
        }
        textLabel.snp.makeConstraints {
            make in make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.left.equalTo(titleLabel.snp.left)
        }
        return view
    }()
    
    lazy var SideEffectView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.frame = CGRect(x: 0, y: 0, width: 327, height: 141)
        var titleLabel = UILabel()
        titleLabel.text = "부작용"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        var textLabel = UILabel()
        textLabel.text = "텍스트"
        view.addSubview(titleLabel)
        view.addSubview(textLabel)
        titleLabel.snp.makeConstraints {make in make.top.equalTo(view.snp.top).offset(17)
            make.left.equalTo(22)
        }
        textLabel.snp.makeConstraints {
            make in make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.left.equalTo(titleLabel.snp.left)
        }
       return view
    }()
    
    // 질병 정보 뷰
    lazy var MediInfoView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.frame = CGRect(x: 0, y: 0, width: 327, height: 221)
        var titleLabel = UILabel()
        titleLabel.text = "감기"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        var subtitleLabel = UILabel()
        subtitleLabel.text = "복용 횟수"
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        var textLabel = UILabel()
        textLabel.text = "텍스트"
        var countLabel = UILabel()
        countLabel.text = "n회"
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(textLabel)
        view.addSubview(countLabel)
        titleLabel.snp.makeConstraints {
            make in make.top.equalTo(view.snp.top).offset(17)
            make.left.equalTo(22)
        }
        textLabel.snp.makeConstraints {
            make in
            make.size.equalTo(CGSize(width: 283, height: 66))
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.left.equalTo(titleLabel.snp.left)
        }
        subtitleLabel.snp.makeConstraints {
            make in make.top.equalTo(textLabel.snp.bottom).offset(6)
            make.left.equalTo(titleLabel.snp.left)
        }
        countLabel.snp.makeConstraints {
            make in make.top.equalTo(subtitleLabel.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
        }
        return view
    }()
    lazy var rightbutton: UIBarButtonItem = {
        let img = UIImage(named: "virus.png")
        let button = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(rightButtonClicked))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(MediInfoView)
        self.view.addSubview(CautionView)
        self.view.addSubview(SideEffectView)
        
        let startColor = UIColor(red: 0.592, green: 0.69, blue: 0.839, alpha: 0.7)
        let endColor = UIColor(red: 0.8, green: 1, blue: 0.937, alpha: 1)
        MediInfoView.setGradient(color1: startColor, color2: endColor)
        SideEffectView.setGradient(color1: startColor, color2: endColor)
        CautionView.setGradient(color1: startColor, color2: endColor)
        
        
        MediInfoView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view.snp.top).offset(120)
            make.size.equalTo(CGSize(width: 327, height: 221))
            make.centerX.equalToSuperview()
        }
        SideEffectView.snp.makeConstraints {
            make in make.top.equalTo(MediInfoView.snp.bottom).offset(26)
            make.size.equalTo(CGSize(width: 327, height: 141))
            make.centerX.equalToSuperview()
        }
        CautionView.snp.makeConstraints {
            make in make.top.equalTo(SideEffectView.snp.bottom).offset(26)
            make.size.equalTo(CGSize(width: 327, height: 116))
            make.centerX.equalToSuperview()
        }
    }
    @objc func rightButtonClicked() {
            let mainViewController = DiseasePageViewController()
            self.navigationController?.pushViewController(mainViewController, animated: true)
    }
}
