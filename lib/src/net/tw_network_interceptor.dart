import 'package:dio/dio.dart';
import 'package:tw_logger/src/helper/tw_network_helper.dart';
import 'package:tw_logger/src/net/tw_network.dart';
import 'package:tw_logger/src/tw_logger_configure.dart';

class TWNetworkSetting {
  /// update network interceptor
  static updateInterceptor(Dio dio) {
    if (TWLoggerConfigure().open) {
      if (dio.interceptors.any((element) => element is TWNetworkInterceptor)) {
        return;
      }
      dio.interceptors.add(TWNetworkInterceptor());
    } else {
      dio.interceptors.removeWhere(
        (element) => element is TWNetworkInterceptor,
      );
    }
  }
}

class TWNetworkInterceptor extends InterceptorsWrapper {
  final requestsMap = <RequestOptions, TWNetworkEvent>{};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    TWNetworkEvent event = TWNetworkEvent.now(
      request: options.toRequest(),
      error: null,
      response: null,
    );
    requestsMap[options] = event;
    await TWNetworkHelper.handleNetworkCache(
      id: options.hashCode,
      event: event,
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // find request event and update response
    TWNetworkEvent? event = requestsMap[response.requestOptions];
    if (event != null) {
      event.response = response.toResponse();
    } else {
      // create new event
      event = TWNetworkEvent.now(
        request: response.requestOptions.toRequest(),
        response: response.toResponse(),
        error: null,
      );
      requestsMap[response.requestOptions] = event;
    }
    await TWNetworkHelper.handleNetworkCache(
      id: response.requestOptions.hashCode,
      event: event,
    );
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    super.onError(err, handler);
    TWNetworkEvent? event = requestsMap[err.requestOptions];
    if (event != null) {
      event
        ..error = err.toNetworkError()
        ..response = err.response?.toResponse();
    } else {
      // create new event
      event = TWNetworkEvent.now(
        request: err.requestOptions.toRequest(),
        response: err.response?.toResponse(),
        error: err.toNetworkError(),
      );
      requestsMap[err.requestOptions] = event;
    }
    await TWNetworkHelper.handleNetworkCache(
      id: err.requestOptions.hashCode,
      event: event,
    );
    handler.next(err);
  }
}

extension _RequestOptionsExtension on RequestOptions {
  TWNetworkRequest toRequest() => TWNetworkRequest(
        uri: uri.toString(),
        data: data,
        method: method,
        headers: TWNetworkHeaders(
          headers.entries.map(
            (kv) => MapEntry(kv.key, '${kv.value}'),
          ),
        ),
      );
}

extension _ResponseExtension on Response {
  TWNetworkResponse toResponse() => TWNetworkResponse(
        data: data,
        statusCode: statusCode ?? -1,
        statusMessage: statusMessage ?? 'unkown',
        time: DateTime.now(),
        headers: TWNetworkHeaders(
          headers.map.entries.fold<List<MapEntry<String, String>>>(
            [],
            (p, e) => p..addAll(e.value.map((v) => MapEntry(e.key, v))),
          ),
        ),
      );
}

extension _DioErrorExtension on DioException {
  TWNetworkError toNetworkError() => TWNetworkError(message: toString());
}
