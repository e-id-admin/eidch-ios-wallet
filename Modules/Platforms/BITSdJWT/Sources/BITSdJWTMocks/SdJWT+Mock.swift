#if DEBUG
import Foundation
@testable import BITSdJWT
@testable import BITTestingCore

extension SdJWT {

  struct Mock {

    // MARK: Internal

    static let sample: SdJWT = decodeRawText(fromFile: sampleFilename)
    static let sampleData: Data = getData(fromFile: sampleFilename)

    static let flat: SdJWT = decodeRawString(flatJwt + SdJWT.disclosuresSeparator + disclosures.joined(separator: SdJWT.disclosuresSeparator) + SdJWT.disclosuresSeparator)
    /*
      {
       "_sd":[
          "YRLf606clwt4-hjyGze49ySFi6VCmwb9n5hwb4VUJSY",
          "QhuvIMQd5LyX8gOR3weVzSY0yGZGGHdVXY0E-NhhUfw",
          "ql6yBMb-5Ql1gG833J1o3poFIDLVt9Ck79astQeVYb0"
       ],
       "_sd_alg":"sha-256"
      }
     */
    static let flatJwt = getString(fromFile: sampleFlatJwtFilename, bundle: Bundle.module)

    // ["test_salt_1", "test_key_1", "test_value_1"]
    static let disclosure1 = "WyJ0ZXN0X3NhbHRfMSIsICJ0ZXN0X2tleV8xIiwgInRlc3RfdmFsdWVfMSJd"
    // ["test_salt_2", "test_key_2", "test_value_2"]
    static let disclosure2 = "WyJ0ZXN0X3NhbHRfMiIsICJ0ZXN0X2tleV8yIiwgInRlc3RfdmFsdWVfMiJd"
    // ["test_salt_3", "test_key_3", "test_value_3"]
    static let disclosure3 = "WyJ0ZXN0X3NhbHRfMyIsICJ0ZXN0X2tleV8zIiwgInRlc3RfdmFsdWVfMyJd"
    static let disclosures = [disclosure1, disclosure2, disclosure3]

    static let sampleNoDigests: Data = getData(fromFile: sampleNoDigestsFilename)
    static let sampleDigestNotFound: Data = getData(fromFile: sampleDigestNotFoundFilename)

    // MARK: Private

    private static let sampleFilename = "sd-jwt-sample"
    private static let sampleFlatJwtFilename = "sd-jwt-flat-jwt"
    private static let sampleNoDigestsFilename = "sd-jwt-no-digests"
    private static let sampleDigestNotFoundFilename = "sd-jwt-digest-not-found"

    private static func decodeRawText(fromFile filename: String, bundle: Bundle = Bundle.module) -> SdJWT {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do { return try SdJWT(from: String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")) }
      catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }

    private static func decodeRawString(_ rawString: String) -> SdJWT {
      do { return try SdJWT(from: rawString) }
      catch { fatalError("Error reading rawString: \(error.localizedDescription)") }
    }

    private static func getData(fromFile filename: String, bundle: Bundle = Bundle.module) -> Data {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do {
        let text = try String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")
        return text.data(using: .utf8) ?? Data()
      } catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }

  }

}
#endif
