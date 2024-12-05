import Foundation

// MARK: - CertificateLoader

/// `CertificateLoader`: A helper struct for loading security certificates from a specified bundle.
///
///  Only DER certificates (binary) are loadable with the Security framework.
///  If you have a PEM certificate, convert it to a DER certificate first:
///  $ openssl x509 -outform der -in certificate.pem -out certificate.der
public struct CertificateLoader {

  /// Loads a DER-encoded certificate from a specified bundle.
  /// - Parameters:
  ///   - name: The name of the certificate file.
  ///   - bundle: The bundle from which to load the certificate.
  /// - Returns: An optional `SecCertificate` object if the certificate is successfully loaded, otherwise `nil`.
  public static func loadDERCertificate(named name: String, from bundle: Bundle) -> SecCertificate? {
    guard
      let path = bundle.path(forResource: name, ofType: CertificateExtension.der.rawValue),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData
    else { return nil }
    return SecCertificateCreateWithData(nil, data)
  }

}

// MARK: CertificateLoader.CertificateExtension

extension CertificateLoader {
  private enum CertificateExtension: String {
    case der
  }
}
