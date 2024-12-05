import BITAnyCredentialFormat
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialShared
@testable import BITOpenID

@testable import BITPresentation
@testable import BITTestingCore

final class GetCompatibleCredentialsUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repositorySpy = CredentialRepositoryProtocolSpy()
    fieldValidatorSpy = AnyPresentationFieldsValidatorProtocolSpy()
    useCase = GetCompatibleCredentialsUseCase(repository: repositorySpy, anyPresentationFieldsValidator: fieldValidatorSpy)
  }

  func testExecute_success() async throws {
    let mockCredentials: [Credential] = [.Mock.sample, .Mock.sample]
    repositorySpy.getAllReturnValue = mockCredentials
    fieldValidatorSpy.validateWithReturnValue = [.string("Smith"), .string("John"), .string("\(Date.now.timeIntervalSince1970)"), .string("Zürich"), .string("A1")]
    XCTAssertTrue(mockCredentials.count > 1, "relevant only if there is compatible / no compatible credentials")

    let compatibleCredentials = try await useCase.execute(using: .Mock.VcSdJwt.sample)

    guard let firstCompatibleCredential = compatibleCredentials.first else {
      XCTFail("No compatible credentials found")
      return
    }
    XCTAssertFalse(firstCompatibleCredential.value.isEmpty)

    XCTAssertTrue(repositorySpy.getAllCalled)
    XCTAssertEqual(1, repositorySpy.getAllCallsCount)
  }

  func testExecute_missingOneMatchingField() async throws {
    let mockCredentials: [Credential] = [.Mock.sample, .Mock.sample]
    repositorySpy.getAllReturnValue = mockCredentials
    fieldValidatorSpy.validateWithReturnValue = [.string("Smith"), .string("John")]

    do {
      _ = try await useCase.execute(using: .Mock.VcSdJwt.sample)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCompatibleCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertTrue(fieldValidatorSpy.validateWithCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_additionalMatchingField() async throws {
    let mockCredentials: [Credential] = [.Mock.sample, .Mock.sample]
    repositorySpy.getAllReturnValue = mockCredentials
    fieldValidatorSpy.validateWithReturnValue = [.string("additional field"), .string("Smith"), .string("John"), .string("\(Date.now.timeIntervalSince1970)")]

    do {
      _ = try await useCase.execute(using: .Mock.UnknownFormat.sample)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCompatibleCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertTrue(fieldValidatorSpy.validateWithCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_emptyWallet() async throws {
    repositorySpy.getAllReturnValue = []
    do {
      _ = try await useCase.execute(using: .Mock.VcSdJwt.sample)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCredentialsInWallet {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertEqual(1, repositorySpy.getAllCallsCount)
      XCTAssertFalse(fieldValidatorSpy.validateWithCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_noMatchingFormats() async throws {
    repositorySpy.getAllReturnValue = [.Mock.sample]
    fieldValidatorSpy.validateWithThrowableError = CredentialFormatError.formatNotSupported
    do {
      _ = try await useCase.execute(using: .Mock.UnknownFormat.sample)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCompatibleCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertTrue(fieldValidatorSpy.validateWithCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_noMatchingFields() async throws {
    repositorySpy.getAllReturnValue = [.Mock.sample]
    fieldValidatorSpy.validateWithReturnValue = []
    do {
      _ = try await useCase.execute(using: .Mock.VcSdJwt.sample)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCompatibleCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertTrue(fieldValidatorSpy.validateWithCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  // MARK: Private

  private var useCase = GetCompatibleCredentialsUseCase()
  private var fieldValidatorSpy = AnyPresentationFieldsValidatorProtocolSpy()
  private var repositorySpy = CredentialRepositoryProtocolSpy()
}
