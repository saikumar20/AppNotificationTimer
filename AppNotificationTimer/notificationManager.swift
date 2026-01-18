import Foundation
import UserNotifications

enum NotificationAccessStatus {
    case authorized
    case denied
    case notDetermined
    case provisional
    case ephemeral
    case unknown
}

class NotificationManager {
    
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    // MARK: - Request Permission
    func requestNotificationPermission(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            completion(granted, error)
        }
    }
    
    // MARK: - Schedule Notification
    func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date,
        completion: @escaping (Error?) -> Void
    ) {
        // Validate date is in the future
        guard date > Date() else {
            let error = NSError(
                domain: "NotificationManager",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: "Notification date must be in the future"]
            )
            completion(error)
            return
        }
        
        // Create date components
        let components: Set<Calendar.Component> = [.minute, .hour, .day, .month, .year]
        let dateComponents = Calendar.current.dateComponents(components, from: date)
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // Create request
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // Add notification
        notificationCenter.add(request) { error in
            completion(error)
        }
    }
    
    // MARK: - Check Permission Status
    func checkPermissionStatus(completion: @escaping (NotificationAccessStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                completion(.notDetermined)
            case .denied:
                completion(.denied)
            case .authorized:
                completion(.authorized)
            case .provisional:
                completion(.provisional)
            case .ephemeral:
                completion(.ephemeral)
            @unknown default:
                completion(.unknown)
            }
        }
    }
    
    // MARK: - Get Pending Notifications
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
    
    // MARK: - Cancel Notification
    func cancelNotification(withId id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // MARK: - Cancel All Notifications
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
