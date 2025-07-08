import '../network/api_service.dart';

class ActionResult<T> {
  late Status status;
  late String message;
  late T? data;
  ActionResult({required this.status, required this.message, this.data});

  ActionResult.fromServerResponse(
      {required ServerResponse response,
      required T Function(dynamic data) generateData}) {
    status = _StatusExtensionMap.state(response.status);
    message = response.message;
    data = status == Status.success ? generateData(response.data) : null;
  }

  ActionResult.error({String msg = "Request failed! Unknown error occurred."}) {
    status = Status.error;
    message = msg;
  }
}

enum Status { success, error }

extension _StatusExtensionMap on Status {
  static const _valueMap = {Status.error: false, Status.success: true};

  bool get value => _valueMap[this] ?? false;
  static Status state(bool value) =>
      _valueMap.keys.firstWhere((element) => element.value == value,
          orElse: () => Status.error);
}
