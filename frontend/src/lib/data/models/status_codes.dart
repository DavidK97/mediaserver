class StatusCodes {
  static const int statusOK = 200; // RFC 7231, 6.3.1
  static const int statusCreated = 201; // RFC 7231, 6.3.2
  static const int statusAccepted = 202; // RFC 7231, 6.3.3
  static const int statusMultiStatus = 207; // RFC 4918, 11.1

  static const List<int> requestOK = [
    statusOK,
    statusCreated,
    statusAccepted,
    statusMultiStatus
  ];

  static const int statusBadRequest = 400; // RFC 7231, 6.5.1
  static const int statusUnauthorized = 401; // RFC 7235, 3.1
  static const int statusForbidden = 403; // RFC 7231, 6.5.3
  static const int statusNotFound = 404; // RFC 7231, 6.5.4
  static const int statusMethodNotAllowed = 405; // RFC 7231, 6.5.5
  static const int statusNotAcceptable = 406; // RFC 7231, 6.5.6
  static const int statusRequestTimeout = 408; // RFC 7231, 6.5.7
  static const int statusConflict = 409; // RFC 7231, 6.5.8
  static const int statusGone = 410; // RFC 7231, 6.5.9
  static const int statusLocked = 423; // RFC 4918, 11.3
  static const int statusTooManyRequests = 429; // RFC 6585, 4

  static const List<int> requestClientError = [
    statusBadRequest,
    statusUnauthorized,
    statusForbidden,
    statusNotFound,
    statusMethodNotAllowed,
    statusNotAcceptable,
    statusRequestTimeout,
    statusConflict,
    statusGone,
    statusLocked,
    statusTooManyRequests,
  ];

  static const int statusInternalServerError = 500; // RFC 7231, 6.6.1
  static const int statusNotImplemented = 501; // RFC 7231, 6.6.2
  static const int statusBadGateway = 502; // RFC 7231, 6.6.3
  static const int statusServiceUnavailable = 503; // RFC 7231, 6.6.4
  static const int statusGatewayTimeout = 504; // RFC 7231, 6.6.5
  static const int statusHTTPVersionNotSupported = 505; // RFC 7231, 6.6.6
  static const int statusVariantAlsoNegotiates = 506; // RFC 2295, 8.1
  static const int statusInsufficientStorage = 507; // RFC 4918, 11.5
  static const int statusLoopDetected = 508; // RFC 5842, 7.2
  static const int statusNotExtended = 510; // RFC 2774, 7
  static const int statusNetworkAuthenticationRequired = 511; // RFC 6585, 6

  static const List<int> requestServerError = [
    statusInternalServerError,
    statusNotImplemented,
    statusBadGateway,
    statusServiceUnavailable,
    statusGatewayTimeout,
    statusHTTPVersionNotSupported,
    statusVariantAlsoNegotiates,
    statusInsufficientStorage,
    statusLoopDetected,
    statusNotExtended,
    statusNetworkAuthenticationRequired,
  ];
}
