import Foundation
import MessageUI

@MainActor
final class EmailService: NSObject, MFMailComposeViewControllerDelegate {
    static let shared = EmailService()

    private override init() {
        super.init()
    }

    func canSendMail() -> Bool {
        MFMailComposeViewController.canSendMail()
    }

    func composeEmail(to email: String, subject: String = "", body: String = "") -> MFMailComposeViewController? {
        guard canSendMail() else { return nil }
        let composer = MFMailComposeViewController()
        composer.setToRecipients([email])
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        composer.mailComposeDelegate = self
        return composer
    }

    nonisolated func mailComposeController(_ controller: MFMailComposeViewController,
                                            didFinishWith result: MFMailComposeResult,
                                            error: Error?) {
        controller.dismiss(animated: true)
    }
}
