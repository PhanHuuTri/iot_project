
import 'package:logger/logger.dart';
import 'package:web_iot/core/configuration/api_config.dart';

final _logger = Logger();

logDebug(dynamic content) {
  if (ApiConfig.client != ApiClient.me) return;
  _logger.d(content, null, StackTrace.empty);
}

logInfo(dynamic content) {
  if (ApiConfig.client != ApiClient.me) return;
  _logger.i(content);
}

logWarning(dynamic content) {
  if (ApiConfig.client != ApiClient.me) return;
  _logger.w(content);
}

logError(dynamic content) {
  _logger.e(content);
}

logVerbose(dynamic content) {
  if (ApiConfig.client != ApiClient.me) return;
  _logger.v(content);
}

logWTF(dynamic content) {
  if (ApiConfig.client != ApiClient.me) return;
  _logger.wtf(content);
}
