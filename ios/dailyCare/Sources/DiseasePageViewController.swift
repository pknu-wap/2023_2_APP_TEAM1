//
//  DiseaseViewController.swift
//  dailyCare
//
//  Created by 노현민 on 11/20/23.
//

import Foundation
import UIKit
import SnapKit
import Combine

class DiseasePageViewController: UIViewController {
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor,
            UIColor.cyan.cgColor
        ]
        gradient.locations = [0, 0.25, 1]
        return gradient
    }()
    
    
    lazy var rightbutton: UIBarButtonItem = {
        let img = UIImage(named: "medi.png")
        let button = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(rightButtonClicked))
        return button
    }()
    
    // 주의사항 뷰
    lazy var CautionView: UIView = {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 327, height: 156)
        view.snp.makeConstraints {
            make in make.size.equalTo(CGSize( width: view.frame.width, height: view.frame.height))
        }
        view.layer.cornerRadius = 10
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
    
    
    // 질병 정보 뷰
    lazy var DiseaseInfoView: UIView = {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 327, height: 332)
        view.snp.makeConstraints {
            make in make.size.equalTo(CGSize( width: view.frame.width, height: view.frame.height))
        }
        
        var titleLabel = UILabel()
        titleLabel.text = "감기"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        var subtitleLabel = UILabel()
        subtitleLabel.text = "상세 정보"
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        var textLabel = UILabel()
        textLabel.text = "텍스트"
        view.addSubview(titleLabel)
        view.addSubview(textLabel)
        view.addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints {
            make in make.top.equalTo(view.snp.top).offset(17)
            make.left.equalTo(22)
        }
        subtitleLabel.snp.makeConstraints {
            make in make.top.equalTo(titleLabel.snp.bottom).offset(71)
            make.left.equalTo(titleLabel.snp.left)
        }
        textLabel.snp.makeConstraints {
            make in make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.left.equalTo(titleLabel.snp.left)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        let startColor = UIColor(red: 0.592, green: 0.69, blue: 0.839, alpha: 0.7)
        let endColor = UIColor(red: 0.8, green: 1, blue: 0.937, alpha: 1)
        self.navigationItem.rightBarButtonItem = self.rightbutton
        self.title = "상세 정보"
        self.view.addSubview(DiseaseInfoView)
        self.view.addSubview(CautionView)
        
        DiseaseInfoView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view.snp.top).offset(120)
            make.centerX.equalToSuperview()
        }
        
        CautionView.snp.makeConstraints {
            make in make.top.equalTo(DiseaseInfoView.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
        }
        DiseaseInfoView.setGradient(color1: startColor, color2: endColor)
        print(DiseaseInfoView.snp.width)
        CautionView.setGradient(color1: startColor, color2: endColor)
        
    }
    @objc func rightButtonClicked() {
            let mainViewController = mediPageViewController()
            self.navigationController?.pushViewController(mainViewController, animated: true)
}
        }
extension UIView{
    func setGradient(color1:UIColor,color2:UIColor){
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.cornerRadius = 15
        gradient.borderWidth = 1
        gradient.borderColor = UIColor(red: 0.816, green: 0.863, blue: 0.882, alpha: 1).cgColor
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        }
}
