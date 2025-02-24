#warning("TODO: Delete this file once real MRZ implementation is ready.")
import Foundation

// MARK: - MRZData

struct MRZData: Decodable, Identifiable {
  var id = UUID()
  let displayName: String
  let payload: EIDRequestPayload

  enum CodingKeys: CodingKey {
    case displayName
    case payload
  }
}

// MARK: MRZData.Mock

extension MRZData {
  struct Mock {
    static var array: [MRZData] {
      guard
        let url = Bundle.module.url(forResource: "eid-request-payloads", withExtension: "json"),
        let data = try? Data(contentsOf: url)
      else {
        return []
      }

      return (try? JSONDecoder().decode([MRZData].self, from: data)) ?? []
    }
  }
}
