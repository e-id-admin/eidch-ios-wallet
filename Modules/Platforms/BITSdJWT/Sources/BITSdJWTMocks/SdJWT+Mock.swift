import Foundation
@testable import BITSdJWT
@testable import BITTestingCore

extension SdJWT: Mockable {

  struct Mock {

    // MARK: Internal

    static let sample: SdJWT = decodeRawText(fromFile: sampleFilename)
    static let sampleData: Data = getData(fromFile: sampleFilename)

    static let sampleNoDigests: Data = getData(fromFile: sampleNoDigestsFilename)
    static let sampleDigestNotFound: Data = getData(fromFile: sampleDigestNotFoundFilename)

    // MARK: Private

    private static let sampleFilename = "sd-jwt-sample"
    private static let sampleNoDigestsFilename = "sd-jwt-no-digests"
    private static let sampleDigestNotFoundFilename = "sd-jwt-digest-not-found"

    private static func decodeRawText(fromFile filename: String, bundle: Bundle = Bundle.module) -> SdJWT {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do { return try SdJWT(from: String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")) }
      catch { fatalError("Error reading the file: \(error.localizedDescription)") }
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
