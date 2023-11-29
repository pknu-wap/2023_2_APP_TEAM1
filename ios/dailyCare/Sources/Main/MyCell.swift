//
//  MyCell.swift
//  CarouselView
//  옆으로 넘기는 카드 슬라이드 윈도우 조절 부분
//

import UIKit
import SnapKit

class MyCell: UICollectionViewCell {

    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }

    var model: String? { didSet { bind() } }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    lazy var bottomRightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(bottomRightLabel)
    }

    private func configure() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
        }

        bottomRightLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }

        let startColor = UIColor(red: 1.0, green: 0.53, blue: 0.81, alpha: 1.0).cgColor
        let endColor = UIColor(red: 0.95, green: 0.82, blue: 0.99, alpha: 1.0).cgColor
                
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
                
        gradientLayer.colors = [startColor, endColor]
               
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 중간 상단
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 중간 하단

        // 그라데이션 레이어를 셀의 레이어로 추가
        layer.insertSublayer(gradientLayer, at: 0)
  
        layer.cornerRadius = 20
    }

    private func bind() {
        titleLabel.text = model
        bottomRightLabel.text = model // You can replace this with the appropriate text for the bottom-right label
    }
}

extension MyCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 원하는 셀 크기를 CGSize로 반환합니다.
        return CGSize(width: 100, height: 100) // 가로와 세로 크기를 조절하실 수 있습니다.
    }
}
