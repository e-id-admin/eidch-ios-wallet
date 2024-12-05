import Factory

extension Container {
  var demoCredentialPattern: Factory<String> {
    self { "^([^:]+:){3}identifier-reg(-.)?\\.trust-infra\\.swiyu-int\\.admin\\.ch:.*" }
  }
}
