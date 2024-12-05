import BITL10n
import SwiftUI

struct DataInformationView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: .x10) {
      Text(L10n.dataAnalysisTitle)
        .font(.custom.title)

      Text(L10n.dataAnalysisText)

      Spacer()
    }
    .padding(.horizontal, .x8)
    .padding(.vertical, .x4)
    .navigationTitle(L10n.dataAnalysisScreenTitle)
  }
}
