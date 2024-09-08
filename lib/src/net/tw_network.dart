class TWNetworkEvent {
  TWNetworkEvent({
    this.request,
    this.response,
    this.error,
    this.time,
  });
  TWNetworkEvent.now({
    this.request,
    this.response,
    this.error,
  }) : time = DateTime.now();

  TWNetworkRequest? request;
  TWNetworkResponse? response;
  TWNetworkError? error;
  DateTime? time;
}

class TWNetworkHeaders {
  TWNetworkHeaders(Iterable<MapEntry<String, String>> entries)
      : entries = entries.toList();
  TWNetworkHeaders.fromMap(Map<String, String> map)
      : entries = map.entries as List<MapEntry<String, String>>;

  final List<MapEntry<String, String>> entries;

  bool get isNotEmpty => entries.isNotEmpty;
  bool get isEmpty => entries.isEmpty;

  Iterable<T> map<T>(T Function(String key, String value) cb) =>
      entries.map((e) => cb(e.key, e.value));

  @override
  String toString() {
    return entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
}

class TWNetworkRequest {
  TWNetworkRequest({
    required this.uri,
    required this.method,
    required this.headers,
    this.data,
  });

  final String uri;
  final String method;
  final TWNetworkHeaders headers;
  final dynamic data;

  @override
  String toString() {
    return 'uri:\n $uri \n method:\n $method \n headers:\n $headers \n data:\n $data';
  }
}

/// Http response details.
class TWNetworkResponse {
  TWNetworkResponse({
    required this.headers,
    required this.statusCode,
    required this.statusMessage,
    this.time,
    this.data,
  });

  final TWNetworkHeaders headers;
  final int statusCode;
  final String statusMessage;
  final DateTime? time;
  final dynamic data;

  @override
  String toString() {
    return 'headers:\n $headers \n statusCode:\n $statusCode \n statusMessage:\n $statusMessage \n data:\n $data, time: $time';
  }
}

/// Network error details.
class TWNetworkError {
  TWNetworkError({required this.message});

  final String message;

  @override
  String toString() => message;
}
