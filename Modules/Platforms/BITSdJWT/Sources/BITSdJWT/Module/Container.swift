import Factory

extension Container {

  var vcSdJwtDecoder: Factory<VcSdJwtDecoderProtocol> {
    self { VcSdJwtDecoder() }
  }
}
