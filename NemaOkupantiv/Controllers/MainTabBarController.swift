//
//  MainTabBarController.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 06.01.2024.
//

import UIKit

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    private let stateMapViewController = StateMapViewController()
    private let airAlarmViewController = AirAlarmViewController()
    private let nezlamnistViewController = NezlamnistViewController()
    private let shelterViewController = ShelterViewController()
    private let renameViewController = RenameViewController()
    private let saveEcoViewController = SaveEcoViewController()
    private var viewControllersOrder: [Int] = [] // массив последовательности
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // вызываем загрузку сайтов сразу
        stateMapViewController.loadMapPage()
        airAlarmViewController.loadAlarmPage()
        nezlamnistViewController.loadPointPage()
        shelterViewController.loadShelterPage()
        renameViewController.loadRenamePage()
        saveEcoViewController.loadSaveEcoPage()
        print("Calling loadMapPage")
        print("Calling loadAlarmPage")
        print("Calling loadPointPage")
        generateTabBar()
        delegate = self
    }
    // вызываем при возврате в приложение
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // вызываем загрузку сайтов при возвращении
        stateMapViewController.loadMapPage()
        airAlarmViewController.loadAlarmPage()
        nezlamnistViewController.loadPointPage()
        shelterViewController.loadShelterPage()
        renameViewController.loadRenamePage()
        saveEcoViewController.loadSaveEcoPage()
        
        print("RECalling loadPointPage")
        print("RECalling loadMapPage")
        print("RECalling loadAlarmPage")
    }
    // создаем таб бар
    private func generateTabBar() {
        // Загружаем сохраненное значение порядка вкладок из UserDefaults
        if let savedOrder = UserDefaults.standard.array(forKey: "viewControllersOrderKey") as? [Int], !savedOrder.isEmpty {
            viewControllersOrder = savedOrder
        } else {
            // Используем значение по умолчанию, если сохраненный порядок пуст
            viewControllersOrder = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        }
        // Инициализируем вкладки с сохраненным порядком
        viewControllers = viewControllersOrder.compactMap { tag in
            switch tag {
            case 0:
                return generateVC(viewController: DateViewController(), title: "Сьогодні", image: UIImage(systemName: "calendar"), tag: tag)
            case 1:
                return generateVC(viewController: OkupantsViewController(), title: "Статистика", image: UIImage(systemName: "chart.bar"), tag: tag)
            case 2:
                return generateVC(viewController: ShelterViewController(), title: "Укриття", image: UIImage(systemName: "lock.shield"), tag: tag)
            case 3:
                return generateVC(viewController: AirAlarmViewController(), title: "Тривога", image: UIImage(systemName: "megaphone"), tag: tag)
            case 4:
                return generateVC(viewController: NezlamnistViewController(), title: "Незламнiсть", image: UIImage(systemName: "mappin.and.ellipse.circle"), tag: tag)
            case 5:
                return generateVC(viewController: InfoViewController(), title: "Інформація", image: UIImage(systemName: "text.justify"), tag: tag)
            case 6:
                return generateVC(viewController: SaveEcoViewController(), title: "SaveEcoBot", image: UIImage(systemName: "wind"), tag: tag)
            case 7:
                return generateVC(viewController: StateMapViewController(), title: "Мапа", image: UIImage(systemName: "map"), tag: tag)
            case 8:
                return generateVC(viewController: RenameViewController(), title: "Перейменування", image: UIImage(systemName: "square.and.pencil"), tag: tag)
            default:
                return nil
            }
        }
    }
    // непосредственно функция создания
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?, tag: Int) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        viewController.tabBarItem.tag = tag
        return viewController
    }
    // обновляем и сохраняем в юзер дефолтс
    func updateTabBarOrder(newOrder: [Int]) {
        viewControllersOrder = newOrder
        print("Updated viewControllersOrder: \(viewControllersOrder)")
        // Сохраняем значение в UserDefaults после каждого обновления
        UserDefaults.standard.set(viewControllersOrder, forKey: "viewControllersOrderKey")
        UserDefaults.standard.synchronize()
        print("Saved viewControllersOrder: \(viewControllersOrder)")
    }
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        if changed {
            // Обновляем порядок контроллеров после настройки таб-бара
            updateTabBarOrder(newOrder: tabBarController.viewControllers?.compactMap { $0.tabBarItem.tag } ?? [])
        }
    }
}
