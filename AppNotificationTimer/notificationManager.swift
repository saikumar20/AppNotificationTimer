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
    
    
    func requestNotificationPermission(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            completion(granted, error)
        }
    }
    
  
    func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date,
        completion: @escaping (Error?) -> Void
    ) {
     
        guard date > Date() else {
            let error = NSError(
                domain: "NotificationManager",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: "Notification date must be in the future"]
            )
            completion(error)
            return
        }
        
       
        let components: Set<Calendar.Component> = [.minute, .hour, .day, .month, .year]
        let dateComponents = Calendar.current.dateComponents(components, from: date)
        
       
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
      
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
       
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
      
        notificationCenter.add(request) { error in
            completion(error)
        }
    }
    
  
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
    
 
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
    
  
    func cancelNotification(withId id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
 
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
