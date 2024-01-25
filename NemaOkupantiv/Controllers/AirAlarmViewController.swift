//
//  AirAlarmViewController.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 07.01.2024.
//

import UIKit
import WebKit
import SnapKit
import SafariServices
import MarqueeLabel

final class AirAlarmViewController: UIViewController, WKNavigationDelegate {
    //MARK: - Properties
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private lazy var bottomGrayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 20/255.0, green: 24/255.0, blue: 29/255.0, alpha: 1.0)
        return view
    }()
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.backgroundColor = .black
        webView.scrollView.delegate = self
        // отключаем жесты/ тапы и т д
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.zoomScale = 1.2
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
        loadAlarmPage()
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
    
    private func setupConstraints() {
        view.backgroundColor = .black
        // подложка нижняя черная
        view.addSubview(bottomMarginView)
        bottomMarginView.layer.zPosition = 800
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-60)
        }
        // подложка нижняя серая
        view.addSubview(bottomGrayView)
        bottomGrayView.layer.zPosition = 790
        bottomGrayView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(150)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-150)
        }
        // сама страница
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
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
    // загрузка страницы
    public func loadAlarmPage() {
        guard let url = URL(string: "https://alerts.in.ua/?pwa") else {
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
        loadAlarmPage()
    }
}
//MARK: extension
extension AirAlarmViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
