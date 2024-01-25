//
//  AppDelegate.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 05.01.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NemaOkupantiv")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: - UserNotificationCenter
    let notificationCenter = UNUserNotificationCenter.current()
    // didFinishLaunchingWithOptions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }

                // Уведомление будет отправлено каждый день
                let content = UNMutableNotificationContent()
                content.title = "\(NSLocalizedString("Вже NemaOkupantiv", comment: ""))"
                content.body = "\(NSLocalizedString("Перевір обстановку в країні🇺🇦", comment: ""))"
                // Уведомление в 12:00
                var dateComponents12 = DateComponents()
                dateComponents12.hour = 12
                dateComponents12.minute = 0
                let trigger12 = UNCalendarNotificationTrigger(dateMatching: dateComponents12, repeats: true)
                let request12 = UNNotificationRequest(identifier: "dailyNotification12", content: content, trigger: trigger12)
                // Уведомление в 18:00
                var dateComponents18 = DateComponents()
                dateComponents18.hour = 18
                dateComponents18.minute = 0
                let trigger18 = UNCalendarNotificationTrigger(dateMatching: dateComponents18, repeats: true)
                let request18 = UNNotificationRequest(identifier: "dailyNotification18", content: content, trigger: trigger18)

                self.notificationCenter.add(request12) { (error) in
                    if let error = error {
                        print("Ошибка при добавлении уведомления (12:00): \(error.localizedDescription)")
                    }
                }

                self.notificationCenter.add(request18) { (error) in
                    if let error = error {
                        print("Ошибка при добавлении уведомления (18:00): \(error.localizedDescription)")
                    }
                }
            }
        }
        notificationCenter.delegate = self
        return true
    }
}
// MARK: - UserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
}
