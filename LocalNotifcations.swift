import SwiftUI
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Success!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleNotification(medication: String, dosage: String, interval: int) {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.subtitle = "Time to take your medication: \(medication)"
        content.body = "Dosage: \(dosage)"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval * 60 * 60, repeats: true)

        let request = UNNotificationRequest(identifier: "notification-identifier", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

struct LocalNotification: View {
    var body: some View {

        VStack(spacing: 40) {
            Button("Request Permission") {
                NotificationManager.instance.requestAuthorization()

            Button("Schedule Notification") {
            }
        }
    }
}

struct LocalNotification_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotification()
    }
}
