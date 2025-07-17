import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

override func didReceive(
    _ request: UNNotificationRequest,
    withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
) {
    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

    guard let bestAttemptContent = bestAttemptContent else {
        return
    }

    if let imageURLString = request.content.userInfo["image"] as? String,
       let imageURL = URL(string: imageURLString) {

        // 🔍 DEBUG PRINT

        downloadImage(from: imageURL) { attachment in
            if let attachment = attachment {
                bestAttemptContent.attachments = [attachment]
            }
            contentHandler(bestAttemptContent)
        }
    } else {
        print("❌ No image found in userInfo")
        contentHandler(bestAttemptContent)
    }
}


    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

 private func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
     URLSession.shared.downloadTask(with: url) { downloadURL, _, _ in
         guard let downloadURL = downloadURL else {
             completion(nil)
             return
         }

         let fileExtension = url.pathExtension
         let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
         let uniqueFileName = UUID().uuidString + "." + fileExtension
         let tmpFile = tmpDir.appendingPathComponent(uniqueFileName)

         do {
             try FileManager.default.moveItem(at: downloadURL, to: tmpFile)
             let attachment = try UNNotificationAttachment(identifier: "image", url: tmpFile, options: nil)
             completion(attachment)
         } catch {
             print("Error creating attachment: \(error)")
             completion(nil)
         }
     }.resume()
 }

}
