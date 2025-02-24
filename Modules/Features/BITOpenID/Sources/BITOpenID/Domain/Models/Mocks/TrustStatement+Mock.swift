#if DEBUG
import Foundation
@testable import BITTestingCore

extension TrustStatement {
  struct Mock {

    // MARK: Internal

    static let validSample: TrustStatement? = decodeRawText(fromFile: "trust-statement-valid-sample")
    static let validSampleItalian: TrustStatement? = decodeRawText(fromFile: "trust-statement-valid-sample-italian")
    static let noKidSample: TrustStatement? = decodeRawText(fromFile: "trust-statement-without-kid-sample")
    static let notTrustedSample: TrustStatement? = decodeRawText(fromFile: "trust-statement-without-trusted-did-sample")
    static let sdJwtSample: String = rawText(fromFile: "trust-statement-valid-sample")
    static let noVctClaimSdJwtSample: String = rawText(fromFile: "trust-statement-sdjwt-without-vct-claim-sample")
    static let unsupportedVctSdJwtSample: String = rawText(fromFile: "trust-statement-sdjwt-unsupported-vct-sample")
    static let invalidSample: String = rawText(fromFile: "trust-statement-invalid-sample")

    static let noTypeSample: String = rawText(fromFile: "trust-statement-without-type")
    static let noSubSample: String = rawText(fromFile: "trust-statement-without-sub")
    static let noActivationDateSample: String = rawText(fromFile: "trust-statement-without-activation-date")
    static let noIssuingDateSample: String = rawText(fromFile: "trust-statement-without-issuing-date")
    static let noVctSample: String = rawText(fromFile: "trust-statement-without-vct")
    static let noExpirationDateSample: String = rawText(fromFile: "trust-statement-without-expiration-date")
    static let noStatusSample: String = rawText(fromFile: "trust-statement-without-status")
    static let incorrectAlgorithmSample: String = rawText(fromFile: "trust-statement-incorrect-algorithm")

    // MARK: Private

    private static func decodeRawText(fromFile filename: String, bundle: Bundle = Bundle.module) -> TrustStatement? {
      try? TrustStatement(from: rawText(fromFile: filename, bundle: bundle))
    }

    private static func rawText(fromFile filename: String, bundle: Bundle = Bundle.module) -> String {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt") else {
        fatalError("Impossible to read \(filename)")
      }

      do {
        return try String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")
      } catch {
        fatalError("Error reading the file: \(error.localizedDescription)")
      }
    }
  }
}
#endif
