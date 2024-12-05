import Foundation

// MARK: - FetchPackagesError

enum FetchPackagesError: Error {
  case fileNotExisting
  case dataWrongFormat
}

// MARK: - FetchPackagesUseCase

struct FetchPackagesUseCase: FetchPackagesUseCaseProtocol {

  // MARK: Lifecycle

  init(filePath: String) {
    self.filePath = filePath
  }

  // MARK: Internal

  func execute() throws -> [PackageDependency] {
    guard let file = Bundle.module.path(forResource: filePath, ofType: "json") else {
      throw FetchPackagesError.fileNotExisting
    }

    let content = try String(contentsOfFile: file)

    if !content.isEmpty {
      guard let data = content.data(using: .utf8) else {
        throw FetchPackagesError.dataWrongFormat
      }

      return try JSONDecoder().decode([PackageDependency].self, from: data)
    }

    throw FetchPackagesError.dataWrongFormat
  }

  // MARK: Private

  private let filePath: String

}
