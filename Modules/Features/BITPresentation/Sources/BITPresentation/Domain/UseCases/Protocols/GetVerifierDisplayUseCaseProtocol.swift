import BITOpenID
import Spyable

@Spyable
protocol GetVerifierDisplayUseCaseProtocol {
  func execute(for verifier: Verifier?, trustStatement: TrustStatement?) -> VerifierDisplay?
}
