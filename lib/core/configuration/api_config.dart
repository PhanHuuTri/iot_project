enum ApiEnvironment {
  development,
}

enum ApiClient { me, local }

class ApiConfig {
  static const ApiClient client = ApiClient.me;
  static const ApiEnvironment environment = ApiEnvironment.development;
  static bool get usingFirebaseStorage {
    switch (client) {
      // TTP Server
      case ApiClient.me:
        switch (environment) {
          case ApiEnvironment.development:
            return false;
        }
      case ApiClient.local:
        return true;
    }
  }

  static bool get allowFullRole {
    switch (client) {
      case ApiClient.me:
        switch (environment) {
          case ApiEnvironment.development:
            return true; // Phase 1
        }
      case ApiClient.local:
        return false;
    }
  }

  static String version = '0.0.1';
}
