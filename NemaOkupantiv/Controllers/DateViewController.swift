//
//  DateViewController.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 06.01.2024.
//

import UIKit
import SnapKit

final class DateViewController: UIViewController {
    //MARK: Properties
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextBold(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .systemGray2
        return label
    }()
    private var dayValue: Int?
    private let customRed = UIColor(red: 204.0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextHeavy(ofSize: 30)
        label.textAlignment = .center
        label.textColor = self.customRed
        return label
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        updateCurrentDate()
        updateDayLabel()
        fetchDataAndDay()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dayLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentDate()
        updateDayLabel()
        fetchDataAndDay()
        dayLabel.isHidden = false

    }
    // перезапуск при повторном запуске
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appWillEnterForeground() {
        updateCurrentDate()
        updateDayLabel()
        fetchDataAndDay()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // Constraints
    private func setupConstraints() {
        view.backgroundColor = .black
        // date current
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        // day number
        view.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        // подложка
        view.addSubview(bottomMarginView)
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(5)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-5)
        }
    }
    // date today
    private func updateCurrentDate() {
        let currentDate = DateDayManager.shared.fetchCurrentDate()
        UIView.transition(with: dateLabel, duration: 2.0, options: .transitionCrossDissolve, animations: {
            self.dateLabel.text = currentDate
        }, completion: nil)
    }
    // day number today
    private func updateDayLabel() {
        // Проверяем, есть ли значение "day"
        guard let dayValue = dayValue else {
            return
        }
        // Используем анимацию с плавным появлением
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.dayLabel.alpha = 0.0
        }, completion: { _ in
            self.dayLabel.text = "\(dayValue)\("-й день війни")"
            // Плавно восстанавливаем видимость
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dayLabel.alpha = 1.0
            }, completion: nil)
        })
    }
    // получаем и обрабатываем дату и день
    private func fetchDataAndDay() {
        DateDayManager.shared.fetchDaysData { [weak self] dayValue in
            guard let self = self else { return }
            
            if let dayValue = dayValue {
                self.dayValue = dayValue
                DispatchQueue.main.async {
                    self.updateDayLabel()
                }
            } else {
                print("Failed to fetch data")
            }
        }
    }
}
