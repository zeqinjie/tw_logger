import 'package:floor/floor.dart';

@entity
class TWNetwork {
  @PrimaryKey(autoGenerate: true)
  int? id;

  /// Request
  /// Request Uri
  String? requestUri;

  /// Request Time
  DateTime requestTime;

  /// Request Method
  String? requestMethod;

  /// Request Headers
  String? requestHeaders;

  /// Request Data
  String? requestData;

  /// Response Time
  DateTime responseTime;

  /// Response Headers
  String? responseHeaders;

  /// Response Status Code
  int? responseStatusCode;

  /// Response Status Message
  String? responseStatusMessage;

  /// Response Data
  String? responseData;

  /// Error
  String? error;

  TWNetwork(
    this.id,
    this.requestTime,
    this.requestUri,
    this.requestMethod,
    this.requestHeaders,
    this.requestData,
    this.responseHeaders,
    this.responseStatusCode,
    this.responseStatusMessage,
    this.responseData,
    this.responseTime,
    this.error,
  );

  factory TWNetwork.optional({
    int? id,
    DateTime? requestTime,
    String? requestUri,
    String? requestMethod,
    String? requestHeaders,
    String? requestData,
    String? responseHeaders,
    int? responseStatusCode,
    String? responseStatusMessage,
    String? responseData,
    DateTime? responseTime,
    String? error,
  }) =>
      TWNetwork(
        id,
        requestTime ?? DateTime.now(),
        requestUri,
        requestMethod,
        requestHeaders,
        requestData,
        responseHeaders,
        responseStatusCode,
        responseStatusMessage,
        responseData,
        responseTime ?? DateTime.now(),
        error,
      );

  TWNetwork copyWith({
    int? id,
    DateTime? time,
    String? requestUri,
    String? requestMethod,
    String? requestHeaders,
    String? requestData,
    String? responseHeaders,
    int? responseStatusCode,
    String? responseStatusMessage,
    String? responseData,
    DateTime? responseTime,
    String? error,
  }) {
    return TWNetwork(
      id,
      time ?? DateTime.now(),
      requestUri,
      requestMethod,
      requestHeaders,
      requestData,
      responseHeaders,
      responseStatusCode,
      responseStatusMessage,
      responseData,
      responseTime ?? DateTime.now(),
      error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TWNetwork &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          requestTime == other.requestTime &&
          requestUri == other.requestUri &&
          requestMethod == other.requestMethod &&
          requestHeaders == other.requestHeaders &&
          requestData == other.requestData &&
          responseHeaders == other.responseHeaders &&
          responseStatusCode == other.responseStatusCode &&
          responseStatusMessage == other.responseStatusMessage &&
          responseData == other.responseData &&
          responseTime == other.responseTime &&
          error == other.error;

  @override
  int get hashCode =>
      id.hashCode ^
      requestTime.hashCode ^
      requestUri.hashCode ^
      requestMethod.hashCode ^
      requestHeaders.hashCode ^
      requestData.hashCode ^
      responseHeaders.hashCode ^
      responseStatusCode.hashCode ^
      responseStatusMessage.hashCode ^
      responseData.hashCode ^
      responseTime.hashCode ^
      error.hashCode;

  @override
  String toString() {
    return '''
      TWNetwork: 
      {
        id: $id, 
        time: $requestTime, 
        requestUri: $requestUri,
        requestMethod: $requestMethod, 
        requestHeaders: $requestHeaders, 
        requestData: $requestData, 
        responseHeaders: $responseHeaders, 
        responseStatusCode: $responseStatusCode,
        responseStatusMessage: $responseStatusMessage, 
        responseData: $responseData,
        responseTime: $responseTime, 
        error: $error
      }''';
  }
}
