import Spyable

@Spyable
protocol SubmitEIDRequestUseCaseProtocol {
  func execute(_ payload: EIDRequestPayload) async throws -> EIDRequestCase
}
