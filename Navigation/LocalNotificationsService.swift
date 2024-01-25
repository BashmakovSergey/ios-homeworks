import Foundation
import UserNotifications

final class LocalNotificationsService {
    
    func registeForLatestUpdatesIfPossible() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.registerCategory()
                self.addNotification(title: "Updates".localized, text: "Check out the latest updates".localized, hour: 19, minute: 00)
            } else {
                print("Access to notifications not granted".localized)
            }
        }
    }
    
    func addNotification(title: String, text: String, hour: Int, minute: Int = 0) {
        removeAllNotifications()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = text
        content.sound = .default
        content.categoryIdentifier = "updates"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ (error) in
            if let error = error {
                print("Error when adding a notification" + ": \(error.localizedDescription)")
            }
        }
        
    }
    
    func registerCategory() {
        let action = UNNotificationAction(identifier: "update", title: "New post", options: [])
        let category = UNNotificationCategory(identifier: "updates", actions: [action], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
