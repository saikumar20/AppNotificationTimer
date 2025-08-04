

import Foundation
import UserNotifications


enum notifictionAccessStatus {
    case authorize
    case denied
    case notDetermined
    case appclip
    case unknown
}

class notificationManager {
    
    static let shared = notificationManager()
    var notificationCenter = UNUserNotificationCenter.current()
    
    
    func requestNotificationPremission(completion : @escaping(Bool, Error?)-> Void) {
        
        notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]) { premissionGranted, error in
            
            completion(premissionGranted,error)
        }
    }
    
    func scheduleNotification(notificationId : String,notificationname : String,notificationBody : String, notificationDate : Date) {
        let component : Set<Calendar.Component> = [.minute, .hour, .day, .month, .year]
        let componentValue  =  Calendar.current.dateComponents(component, from: notificationDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: componentValue, repeats: false)
        
        
        schedulenotificationContennt(trigger: trigger, notificationId: notificationId, notificationname: notificationname, notificationBody: notificationBody)
    }
    
    
    func schedulenotificationContennt(trigger : UNNotificationTrigger,notificationId : String,notificationname : String,notificationBody : String) {
        
        let  notificationncontent = UNMutableNotificationContent()
        notificationncontent.title = notificationname
        notificationncontent.body = notificationBody
        notificationncontent.sound = .default
        
        
        let request = UNNotificationRequest(identifier: notificationId, content: notificationncontent, trigger: trigger)
        notificationCenter.add(request)
        
    }
    
    
    func checkingPremissionStatus(completionn : @escaping(notifictionAccessStatus)-> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                completionn(.notDetermined)
            case .denied:
                completionn(.denied)
            case .authorized:
                completionn(.authorize)
          
            case .provisional:
                completionn(.authorize)
            case .ephemeral:
                completionn(.appclip)
            @unknown default:
                completionn(.unknown)
            }
            
            
        }
    }
    
    
    
}
