#if DEBUG
import Foundation
@testable import BITJWT
@testable import BITTestingCore

extension JWT {

  enum Mock {

    // MARK: Internal

    static let tokenStatusList: String = JWT.getString(fromFile: tokenStatusListFilename, bundle: Bundle.module)
    static let tokenStatusListPayload: Data = Mocker.getData(fromFile: tokenStatusListPayloadFilename, bundle: Bundle.module) ?? Data()
    static let tokenStatusListWrongType: JWT = decodeRawText(fromFile: tokenStatusListWrongTypeFilename)
    static let tokenStatusListWithoutIssuedAt: JWT = decodeRawText(fromFile: tokenStatusListWithoutIssuedAtFilename)
    static let tokenStatusListWrongSubject: JWT = decodeRawText(fromFile: tokenStatusListWrongSubjectFilename)
    static let tokenStatusListWithoutIssuer: JWT = decodeRawText(fromFile: tokenStatusListWithoutIssuerFilename)
    static let tokenStatusListWrongIssuer: JWT = decodeRawText(fromFile: tokenStatusListWrongIssuerFilename)
    static let tokenStatusListNotExpired: JWT = decodeRawText(fromFile: tokenStatusListNotExpiredFilename)
    static let tokenStatusListExpired: JWT = decodeRawText(fromFile: tokenStatusListExpiredFilename)

    // MARK: Private

    private static let tokenStatusListFilename = "token-status-list"
    private static let tokenStatusListPayloadFilename = "token-status-list-payload"
    private static let tokenStatusListWrongTypeFilename = "token-status-list-wrong-type"
    private static let tokenStatusListWithoutIssuedAtFilename = "token-status-list-without-issued-at"
    private static let tokenStatusListWrongSubjectFilename = "token-status-list-wrong-subject"
    private static let tokenStatusListWithoutIssuerFilename = "token-status-list-without-issuer"
    private static let tokenStatusListWrongIssuerFilename = "token-status-list-wrong-issuer"
    private static let tokenStatusListNotExpiredFilename = "token-status-list-not-expired"
    private static let tokenStatusListExpiredFilename = "token-status-list-expired"

    private static func decodeRawText(fromFile filename: String, bundle: Bundle = Bundle.module) -> JWT {
      guard let fileURL = bundle.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do { return try JWT(
        from:
        String(contentsOf: fileURL, encoding: .utf8)
          .replacingOccurrences(of: "\n", with: "")
          .replacingOccurrences(of: "\"", with: "")
      ) } catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }
  }
}
#endif
