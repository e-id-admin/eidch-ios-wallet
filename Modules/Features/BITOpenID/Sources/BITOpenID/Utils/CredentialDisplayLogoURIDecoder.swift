import BITCore
import Foundation

// MARK: - CredentialDisplayLogoURIDecoder

public struct CredentialDisplayLogoURIDecoder {

  // MARK: Public

  public static func decode(_ url: URL) -> URI? {
    let urlString = url.absoluteString

    switch url.scheme {
    case URLScheme.https.rawValue:
      return urlString
    case URLScheme.data.rawValue:
      let components = urlString.split(separator: ",")
      guard urlString.isValid, components.count > 1 else {
        return nil
      }

      return String(components[1])
    default:
      return nil
    }
  }

  public static func decode(_ string: String) -> URI? {
    guard let urlString = URL(string: string) else {
      return nil
    }

    return decode(urlString)
  }

  // MARK: Private

  private enum URLScheme: String {
    case https
    case data
  }
}

public typealias URI = String

extension URI {
  fileprivate var isValid: Bool {
    for format in ValueType.supportedImageTypes where starts(with: "data:\(format.rawValue);base64") {
      return true
    }

    return false
  }
}
