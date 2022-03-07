import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/utils/result_data.dart';

class HttpManager {
  static Future<ResultData> request(
    String url, {
    params,
    queryParams,
    String method = 'GET',
    bool useBaseUrl = true,
    bool isShowError = true,
  }) async {
   
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {
      showErrorMsg( 'Network connection failed');
      return ResultData('Network_connection_failed', 500);
    }

    BaseOptions? options;
    if (options == null) {
      options = new BaseOptions(method: method);
      options.headers = {"Content-Type": "application/json"};
      if (useBaseUrl == true) {
        options.baseUrl = Config.baseUrl;
      }
      options.connectTimeout = 600000;
      options.receiveTimeout = 600000;
    } else {
      options.method = method;
    }

    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, String host, int port) {
        return true;
      };
    };
    try {
      Response response =
          await dio.request(url, data: params, queryParameters: queryParams);
      
      return ResultData(response.data, response.statusCode??200);
    } on DioError catch (e) {
      String msg = "";
      if (e.type == DioErrorType.connectTimeout) {
        // It occurs when url is opened timeout.
        msg = "connectTimeout";
      } else if (e.type == DioErrorType.sendTimeout) {
        // It occurs when url is sent timeout.
        msg = "sendTimeout";
      } else if (e.type == DioErrorType.receiveTimeout) {
        //It occurs when receiving timeout
        msg = "receiveTimeout";
      } else if (e.type == DioErrorType.response) {
        // When the server response, but with a incorrect status, such as 404, 503...
        msg = "response${e.response?.statusMessage}";
      } else if (e.type == DioErrorType.cancel) {
        // When the request is cancelled, dio will throw a error with this type.
        msg = "cancel";
      } 
      if ( msg.isNotEmpty && isShowError) showErrorMsg(msg);
      return ResultData(msg, 500);
    }
  }
}
