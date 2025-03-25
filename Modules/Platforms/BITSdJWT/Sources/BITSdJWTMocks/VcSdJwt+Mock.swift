import Foundation
@testable import BITSdJWT
@testable import BITTestingCore

extension VcSdJwt {

  struct Mock {

    // MARK: Internal

    static let sample: VcSdJwt = decodeRawText(fromFile: sampleFilename)
    static let sampleRaw: String = VcSdJwt.getString(fromFile: sampleFilename, bundle: Bundle.module)
    static let sampleData: Data = Mocker.getData(fromFile: sampleFilename, ofType: "txt", bundle: Bundle.module) ?? Data()
    static let fullSample: VcSdJwt = decodeRawText(fromFile: fullSampleFilename)
    static let sampleNoKeyBinding: VcSdJwt = decodeRawText(fromFile: sampleNoKeyBindingFilename)
    static let sampleNoVct: VcSdJwt = decodeRawText(fromFile: sampleNoVctFilename)
    static let sampleNoStatus: VcSdJwt = decodeRawText(fromFile: sampleNoStatusFilename)
    static let sampleNoIssuer: String = VcSdJwt.getString(fromFile: sampleNoIssuerDataFilename, bundle: Bundle.module)
    static let sampleNonDisclosableClaims: String = VcSdJwt.getString(fromFile: sampleNonDisclosableClaimsFilename, bundle: Bundle.module)

    // MARK: Private

    private static let sampleFilename = "vc-sd-jwt-sample"
    private static let fullSampleFilename = "vc-sd-jwt-full-sample"
    private static let sampleNoKeyBindingFilename = "vc-sd-jwt-no-key-binding"
    private static let sampleNoVctFilename = "vc-sd-jwt-no-vct"
    private static let sampleNoStatusFilename = "vc-sd-jwt-no-status"
    private static let sampleNoIssuerDataFilename = "vc-sd-jwt-no-issuer"
    private static let sampleNonDisclosableClaimsFilename = "vc-sd-jwt-non-disclosable-claims"

    private static func decodeRawText(fromFile filename: String) -> VcSdJwt {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do { return try VcSdJwt(from: String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")) }
      catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }
  }
}
