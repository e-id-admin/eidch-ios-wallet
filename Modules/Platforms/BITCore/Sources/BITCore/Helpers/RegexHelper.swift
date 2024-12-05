import Foundation

public struct RegexHelper {

  /// Check if the given string matches with the pattern
  /// - Parameters:
  ///   - pattern: The regex pattern to apply to the string
  ///   - string: The string to match this regular expression against.
  ///   - options: The regex matching option parameters
  public static func matches(_ pattern: String, in string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
    firstMatch(pattern, in: string, options: options) != nil
  }

  /// Returns the first match for this regex found in the given string.
  /// - Parameters:
  ///   - pattern: The regex pattern to apply to the string
  ///   - string: The string to match this regular expression against.
  ///   - options: The regex matching option parameters
  public static func firstMatch(_ pattern: String, in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
    guard let regex = try? NSRegularExpression(pattern: pattern) else {
      return nil
    }

    let range = NSRange(string.startIndex..<string.endIndex, in: string)
    return regex.firstMatch(in: string, options: options, range: range)
  }
}
