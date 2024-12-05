import SwiftUI

// MARK: - ButtonLibrary

private struct ButtonPlaygrounds: View {

  @State var isHidden = false

  var body: some View {
    List {
      Section("Basic") {
        section(style: .basic, text: "Tap on me ! Oh oui")
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

      Section("Bezeled") {
        section(style: .bezeled, text: "Accept")
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

      Section("bezeledLight") {
        section(style: .bezeledLight)
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
      Section("filledPrimary") {
        section(style: .filledPrimary)
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

      Section("filledSecondary") {
        section(style: .filledSecondary)
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

      Section("filledDestructive") {
        section(style: .filledDestructive)
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

      Section("material") {
        section(style: .material)
          .background(.blue)
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
  }

  @ViewBuilder
  func section(style: CustomButtonStyle, text: String = "Button", imageName: String = "arrow.right") -> some View {
    Group {
      ScrollView(.horizontal, showsIndicators: false) {
        VStack {
          buttonSet(label: { Text(text) }, style: style)
          buttonSet(label: { Text(text) }, style: style, isDisabled: true)
        }
        .padding()
      }

      ScrollView(.horizontal, showsIndicators: false) {
        VStack {
          buttonSet(label: { Label(text, systemImage: imageName) }, style: style)
          buttonSet(label: { Label(text, systemImage: imageName) }, style: style, isDisabled: true)
        }
        .padding()
      }

      ScrollView(.horizontal, showsIndicators: false) {
        VStack {
          circleButtonSet(label: { Image(systemName: imageName) }, style: style)
          circleButtonSet(label: { Image(systemName: imageName) }, style: style, isDisabled: true)
        }
        .padding()
      }
    }
  }

  @ViewBuilder
  func buttonSet(label: () -> some View, style: CustomButtonStyle, isDisabled: Bool = false) -> some View {
    HStack {
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.mini)
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.small)
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.regular)
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.large)
      if #available(iOS 17.0, *) {
        button(label: label, style: style, isDisabled: isDisabled)
          .controlSize(.extraLarge)
      } else {
        // Fallback on earlier versions
      }
    }
  }

  @ViewBuilder
  func circleButtonSet(label: () -> some View, style: CustomButtonStyle, isDisabled: Bool = false) -> some View {
    HStack {
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.mini)
        .clipShape(.circle)
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.small)
        .clipShape(.circle)
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.regular)
        .clipShape(.circle)
      button(label: label, style: style, isDisabled: isDisabled)
        .controlSize(.large)
        .clipShape(.circle)
      if #available(iOS 17.0, *) {
        button(label: label, style: style, isDisabled: isDisabled)
          .controlSize(.extraLarge)
          .clipShape(.circle)
      } else {
        // Fallback on earlier versions
      }
    }
  }

  @ViewBuilder
  func button(label: () -> some View, style: CustomButtonStyle, isDisabled: Bool = false) -> some View {
    Button(action: {}, label: label)
      .buttonStyle(style)
      .disabled(isDisabled)
  }

}

#Preview {
  ButtonPlaygrounds()
}
