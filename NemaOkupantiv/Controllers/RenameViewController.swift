//
//  RenameViewController.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 14.01.2024.
//

import UIKit
import WebKit
import SafariServices
import CoreLocation
import MarqueeLabel

final class RenameViewController: UIViewController, WKNavigationDelegate {
    //MARK: - Properties
    private var locationManager = CLLocationManager()
    private let topMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let clearMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    // бегущая строка
    private let marqueeLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, rate: 160, fadeLength: 10)
        label.trailingBuffer = 0.0
        label.animationCurve = .linear
        label.font = UIFont.SFUITextMedium(ofSize: 24)
        label.textColor = .systemGray2

        let textWithImage = "🚢російський військовий кораблю, іди *****!🚢русский военный корабль, иди *****!"
        let attributedText = NSMutableAttributedString(string: textWithImage)
        
        let imageName = "ship.png"
        let imageSize = CGSize(width: 60, height: 25)
        // Заменяем эмодзи на ship.png
        for emoji in ["🚢", "🚢"] {
            let range = (attributedText.string as NSString).range(of: emoji, options: .backwards)
            
            if let image = UIImage(named: imageName) {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = image
                imageAttachment.bounds = CGRect(origin: .zero, size: imageSize)
                // Выравнивание по вертикали
                let font = UIFont.SFUITextMedium(ofSize: 30)
                let yOffset = (font!.capHeight - imageSize.height) / 2.0
                imageAttachment.bounds.origin.y = yOffset
                
                let imageString = NSAttributedString(attachment: imageAttachment)
                attributedText.replaceCharacters(in: range, with: imageString)
            }
        }
        label.attributedText = attributedText
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextBold(ofSize: 24)
        label.textColor = .systemGray2
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemGray2
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private let refreshButton: UIButton = {
        let button = UIButton()
        let refreshIcon = UIImage(systemName: "arrow.clockwise")
        button.setImage(refreshIcon, for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        loadRenamePage()
        setupLocationManager()
        startMarqueeAnimation()
        updatedateLabel()
        addTarget()
    }
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
    // location
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    private func setupConstraints() {
        view.backgroundColor = .clear
        // подложка
        view.addSubview(bottomMarginView)
        bottomMarginView.layer.zPosition = 900
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-60)
        }
        // страница
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        // top подложка
        view.addSubview(topMarginView)
        topMarginView.layer.zPosition = 800
        topMarginView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(45)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(45)
        }
        // clear top подложка
        view.addSubview(clearMarginView)
        clearMarginView.layer.zPosition = 700
        clearMarginView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(60)
        }
        // бегущая строка
        view.addSubview(marqueeLabel)
        marqueeLabel.layer.zPosition = 900
        marqueeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        // дата НАД бегущей строкой
        view.addSubview(dateLabel)
        dateLabel.layer.zPosition = 990
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(marqueeLabel.snp.top).offset(0)
        }
        // обновить
        view.addSubview(refreshButton)
        refreshButton.layer.zPosition = 910
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(marqueeLabel.snp.bottom).offset(-25)
            make.width.height.equalTo(40)
        }
        // индикатор загрузки
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    // Метод для начала анимации
    private func startMarqueeAnimation() {
        marqueeLabel.type = .continuous
        marqueeLabel.leadingBuffer = 0
        marqueeLabel.shutdownLabel()
    }
    // load web page
    public func loadRenamePage() {
        guard let url = URL(string: "https://misto.lun.ua/derusification?ls=derusification#12.92/48.4763/35.03459") else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    // настройки страницы
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Показ черного фона при начале загрузки страницы
        view.backgroundColor = .black
        // Запуск анимации индикатора загрузки
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Скрытие черного фона и остановка анимации индикатора после завершения загрузки страницы
        view.backgroundColor = .black
        activityIndicator.stopAnimating()
    }
    
    private func addTarget() {
        refreshButton.addTarget(self, action: #selector(refreshButtonAction), for: .touchUpInside)
    }
    
    @objc private func refreshButtonAction() {
        loadRenamePage()
    }
}
//MARK: extension
extension RenameViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                // Ожидаем изменения авторизации
                break
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                // когда доступ запрещен или ограничен
                break
            @unknown default:
                break
            }
        } else {
            // Обработка изменения авторизации для более ранних версий iOS
            if CLLocationManager.authorizationStatus() == .notDetermined {
                // Ожидаем изменения авторизации через делегата
            } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }
}
