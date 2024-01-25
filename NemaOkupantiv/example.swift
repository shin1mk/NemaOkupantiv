//
//  example.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 06.01.2024.
//

/*
 
 updates
 
 - [ ] Корисни линкс е ппо
 - [ ] Е ворог
 - [ ] https://itarmy.com.ua
 - [ ] Тактик мед

 https://misto.lun.ua/shelters?ls=shelters-private%2Cshelters-municipal%2Cshelters-other#5.93/48.644/31.607
 
 
 
 
 label.font = UIFont.SFUITextMedium(ofSize: 24)


 private let dateLabel: UILabel = {
     let label = UILabel()
     label.font = UIFont.SFUITextBold(ofSize: 24)
     label.textColor = .systemGray2
     label.textAlignment = .left
     label.numberOfLines = 2
     return label
 }()
 
 // Функция для обновления dateTimeLabel
 @objc private func updatedateLabel() {
     dateLabel.text = getCurrentDateString()
 }

 // Функция для получения текущей даты
 private func getCurrentDateString() -> String {
     let currentDate = Date()
     // Форматтер для даты
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "dd MMMM yyyy"
     // Преобразование даты в строку
     let currentDateString = dateFormatter.string(from: currentDate)
     
     return currentDateString
 }
 
 view.addSubview(topMarginView)
 topMarginView.layer.zPosition = 800
 topMarginView.snp.makeConstraints { make in
     make.leading.trailing.equalToSuperview()
     make.height.greaterThanOrEqualTo(45)
     make.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(45)
 }
 // низ подложка
 view.addSubview(bottomMarginView)
 bottomMarginView.snp.makeConstraints { make in
     make.leading.trailing.bottom.equalToSuperview()
     make.height.greaterThanOrEqualTo(60)
     make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-60)
 }
 // бегущая строка
 view.addSubview(marqueeLabel)
 marqueeLabel.snp.makeConstraints { make in
     make.leading.trailing.equalToSuperview()
     make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
 }
 // дата НАД бегущей строкой
 view.addSubview(dateLabel)
 dateLabel.snp.makeConstraints { make in
     make.leading.trailing.equalToSuperview().inset(10)
     make.bottom.equalTo(marqueeLabel.snp.top).offset(0)
 }
 // обновить
 view.addSubview(refreshButton)
 refreshButton.snp.makeConstraints { make in
     make.trailing.equalToSuperview()
     make.bottom.equalTo(marqueeLabel.snp.bottom).offset(-25)
     make.width.height.equalTo(40)
 }
 
 
 
 // clear top подложка
 view.addSubview(clearMarginView)
 clearMarginView.layer.zPosition = 700
 clearMarginView.snp.makeConstraints { make in
     make.leading.trailing.equalToSuperview()
     make.height.greaterThanOrEqualTo(60)
     make.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(60)
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */
