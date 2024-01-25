//
//  InfoViewController.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 08.01.2024.
//

import UIKit
import SnapKit

final class InfoViewController: UIViewController {
    //MARK: Properties
    private let topMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextRegular(ofSize: 15)
        label.textAlignment = .left
        label.text = "Загальна інформація\nДодаток створено виключно в інформаційних цілях і не є офіційним. Не рекомендується використовувати його як єдине джерело інформації.\nДодаток є повністю безкоштовним і не містить прихованих покупок. Автор не несе відповідальності за контент, наданий сторонніми джерелами.\nІнформація, що надається додатком, може бути обмеженою.\nДодаток надає доступ до інтернет-ресурсів для отримання інформації.\nДодаток не є повноцінним браузером і деякі веб-сторінки або функції можуть бути обмежені. \n\nНижче наведено перелік усіх джерел, де ви можете переглянути інформацію в повному обсязі або отримати додаткову інформацію. Будь ласка, перейдіть за цими посиланнями на офіційні сторінки джерел.\n\nДжерела:"
        label.textColor = .systemGray2
        label.numberOfLines = 0
        return label
    }()
    private let sourceButton1: UIButton = {
        let button = UIButton()
        button.setTitle("russianWarship.rip", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let sourceButton2: UIButton = {
        let button = UIButton()
        button.setTitle("DeepStateMap.live", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let sourceButton3: UIButton = {
        let button = UIButton()
        button.setTitle("Alerts.in.ua", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let sourceButton4: UIButton = {
        let button = UIButton()
        button.setTitle("Misto.lun.ua", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let sourceButton5: UIButton = {
        let button = UIButton()
        button.setTitle("SaveEcoBot.com", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    // add shelter link
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextRegular(ofSize: 15)
        label.textAlignment = .left
        label.text = "Якщо вам сподобався наш додаток:"
        label.textColor = .systemGray2
        return label
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Поділитися застосунком", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("⭐️ Оцінити додаток", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let supportButton: UIButton = {
        let button = UIButton()
        button.setTitle("☕️ Підтримайте мене", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let letterButton: UIButton = {
        let button = UIButton()
        button.setTitle("✉️ Зв'язатися зі мною", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let clearCacheButton: UIButton = {
        let button = UIButton()
        button.setTitle("🧹 Очистити кеш", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let cacheLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextRegular(ofSize: 12)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .systemGray2
        return label
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        addTarget()
        updateCacheLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCacheLabel()
    }
    //methods
    private func setupConstraints() {
        view.backgroundColor = .black
        // top view
        view.addSubview(topMarginView)
        topMarginView.layer.zPosition = 999
        topMarginView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(0)
        }
        // bottom view
        view.addSubview(bottomMarginView)
        bottomMarginView.layer.zPosition = 999
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(2)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-2)
        }
        // scroll
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // content
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalToSuperview()
        }
        // описание
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        // кнопки
        contentView.addSubview(sourceButton1)
        sourceButton1.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(sourceButton2)
        sourceButton2.snp.makeConstraints { make in
            make.top.equalTo(sourceButton1.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(sourceButton3)
        sourceButton3.snp.makeConstraints { make in
            make.top.equalTo(sourceButton2.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(sourceButton4)
        sourceButton4.snp.makeConstraints { make in
            make.top.equalTo(sourceButton3.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(sourceButton5)
        sourceButton5.snp.makeConstraints { make in
            make.top.equalTo(sourceButton4.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        // my links
        contentView.addSubview(likeLabel)
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceButton5.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(likeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(supportButton)
        supportButton.snp.makeConstraints { make in
            make.top.equalTo(rateButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        contentView.addSubview(letterButton)
        letterButton.snp.makeConstraints { make in
            make.top.equalTo(supportButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }  
        contentView.addSubview(clearCacheButton)
        clearCacheButton.snp.makeConstraints { make in
            make.top.equalTo(letterButton.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }  
        contentView.addSubview(cacheLabel)
        cacheLabel.snp.makeConstraints { make in
            make.top.equalTo(clearCacheButton.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        // ограничение последней кнопки
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(cacheLabel.snp.bottom).offset(10)
        }
    }
    
    private func addTarget(){
        sourceButton1.addTarget(self, action: #selector(openSource1), for: .touchUpInside)
        sourceButton2.addTarget(self, action: #selector(openSource2), for: .touchUpInside)
        sourceButton3.addTarget(self, action: #selector(openSource3), for: .touchUpInside)
        sourceButton4.addTarget(self, action: #selector(openSource4), for: .touchUpInside)
        sourceButton5.addTarget(self, action: #selector(openSource5), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        supportButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
        clearCacheButton.addTarget(self, action: #selector(clearCacheButtonTapped), for: .touchUpInside)
    }
    
    @objc private func openSource1() {
        if let url = URL(string: "https://russianwarship.rip") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openSource2() {
        if let url = URL(string: "https://deepstatemap.live/#7/49.788/29.658") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openSource3() {
        if let url = URL(string: "https://alerts.in.ua") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openSource4() {
        if let url = URL(string: "https://misto.lun.ua/svitlo?ls=nezlamnist%2Csvitlo-coworking%2Csvitlo-coffee-resto%2Csvitlo-products%2Csvitlo-azs%2Csvitlo-health%2Csvitlo-household%2Csvitlo-electronics%2Csvitlo-clothes%2Csvitlo-beauty%2Csvitlo-sport%2Csvitlo-pets%2Csvitlo-auto%2Csvitlo-vacation%2Csvitlo-children%2Csvitlo-post%2Csvitlo-money%2Csvitlo-other#15.01/48.5144/35.02564") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openSource5() {
        if let url = URL(string: "https://www.saveecobot.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func rateButtonTapped() {
        if let url = URL(string: "https://apps.apple.com/app/nemaokupantiv/id6475620811") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func buyButtonTapped() {
        if let url = URL(string: "https://www.buymeacoffee.com/shininswift") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    // share
    @objc private func shareButtonTapped() {
        // Создайте экземпляр UIActivityViewController
        let appURL = URL(string: "https://apps.apple.com/app/nemaokupantiv/id6475620811")!
        let shareText = "Будь у курсі подій у країні!🇺🇦\nЗавантаж NemaOkupantiv🇺🇦 \n\(appURL)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        // Предотвратите показывание контроллера на iPad в поповере
        activityViewController.popoverPresentationController?.sourceView = view
        // Покажите UIActivityViewController
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func letterButtonTapped() {
        let recipient = "shininswift@gmail.com"
        let subject = "NemaOkupantiv🇺🇦"

        let urlString = "mailto:\(recipient)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        if let url = URL(string: urlString ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    // чистим кеш функция
    @objc func clearCacheButtonTapped() {
        // Get the caches directory URL
        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                let cacheFiles = try FileManager.default.contentsOfDirectory(atPath: cachesURL.path)
                
                for file in cacheFiles {
                    try FileManager.default.removeItem(at: cachesURL.appendingPathComponent(file))
                }
                print("Кеш очищен.")
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    DispatchQueue.main.async {
                        self.updateCacheLabel()
                    }
                }
            } catch {
                print("Не удалось очистить кеш: \(error.localizedDescription)")
            }
        }
    }
    // обновляем лейбл кеша
    func updateCacheLabel() {
        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                // Get the size of the caches directory
                let cacheSize = try FileManager.default.sizeOfDirectory(at: cachesURL)
                
                let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(cacheSize), countStyle: .file)
                
                cacheLabel.text = cacheSize > 0 ? "Розмір кешу: \(formattedSize)" : "Розмір кешу: 0 MБ"
            } catch {
                cacheLabel.text = "Не удалось получить размер кеша"
            }
        }
    }
} // end
//MARK: Clear Cache
extension FileManager {
    func sizeOfDirectory(at url: URL) throws -> UInt64 {
        let resourceKeys: [URLResourceKey] = [.isRegularFileKey, .fileSizeKey]

        let enumerator = self.enumerator(at: url, includingPropertiesForKeys: resourceKeys, options: [], errorHandler: nil)

        var totalSize: UInt64 = 0

        for case let fileURL as URL in enumerator! {
            let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
            if resourceValues.isRegularFile ?? false {
                totalSize += UInt64(resourceValues.fileSize ?? 0)
            }
        }

        return totalSize
    }
}
