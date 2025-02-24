import Alamofire
import BITNetworking
import BITOpenID
import Foundation
import Moya

// MARK: - PresentationEndpointError

private enum PresentationEndpointError: Error {
  case incorrectParameters
  case incorrectData
}

// MARK: - PresentationEndpoint

enum PresentationEndpoint {
  case submission(url: URL, presentationBody: PresentationRequestBody)
  case errorSubmission(url: URL, presentationErrorBody: PresentationErrorRequestBody)
}

// MARK: TargetType

extension PresentationEndpoint: TargetType {
  var baseURL: URL {
    switch self {
    case .errorSubmission(url: let url, _),
         .submission(let url, _):
      url
    }
  }

  var path: String {
    switch self {
    case .errorSubmission,
         .submission:
      ""
    }
  }

  var method: Moya.Method {
    switch self {
    case .errorSubmission,
         .submission: .post
    }
  }

  var task: Moya.Task {
    switch self {
    case .submission(_, presentationBody: let presentationBody):
      .requestParameters(parameters: presentationBody.asDictionary(), encoding: URLEncoding.httpBody)
    case .errorSubmission(_, presentationErrorBody: let presentationErrorBody):
      .requestParameters(parameters: presentationErrorBody.asDictionary(), encoding: URLEncoding.httpBody)
    }
  }

  var headers: [String: String]? {
    switch self {
    case .errorSubmission,
         .submission:
      NetworkHeader.form.raw
    }
  }
}
