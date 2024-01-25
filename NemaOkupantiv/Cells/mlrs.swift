//
//  mlrs.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 07.01.2024.
//

import UIKit
import SnapKit

final class mlrs_Cell: UITableViewCell {
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-rszv.png")
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextHeavy(ofSize: 25)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextMedium(ofSize: 14)
        label.text = "Системи залпового вогню"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        updateTitleLabelWithMlrsData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
        updateTitleLabelWithMlrsData()
    }
    
    private func setupConstraints() {
        backgroundColor = .systemGray
        // Добавляем изображение
        addSubview(customImageView)
        customImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(customImageView.snp.height)
        }
        // titleLabel справа
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(customImageView.snp.trailing).offset(30)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(25)
        }
        // subtitleLabel снизу
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.leading.equalTo(customImageView.snp.trailing).offset(30)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(25)
        }
    }
    // плавное появление анимация
    func updateTitleLabelWithMlrsData() {
        WarshipAPIManager.shared.fetchWarfareData { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(WarfareData.self, from: data)
                    let Stats = decodedData.data.stats.mlrs
                    let Increase = decodedData.data.increase.mlrs

                    let increaseText = (Increase > 0) ? "(+\(Increase))" : ""
                    let fullText = "\(Stats)\(increaseText)"

                    DispatchQueue.main.async {
                        UIView.transition(with: self.titleLabel, duration: 0.4, options: .transitionCrossDissolve, animations: {
                            let attributedText = NSMutableAttributedString(string: fullText)
                            let range = (fullText as NSString).range(of: increaseText)
                            // Устанавливаем кастомный цвет, другие свойства и bold для increaseText
                            let customRed = UIColor(red: 204.0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
                            attributedText.addAttribute(.foregroundColor, value: customRed, range: range)
                            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .heavy), range: range)
                            self.titleLabel.attributedText = attributedText
                        }, completion: nil)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}
