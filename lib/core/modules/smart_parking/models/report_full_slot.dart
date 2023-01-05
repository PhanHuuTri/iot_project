import '../../../rest/models/rest_api_response.dart';

class ReportFullSlotModel extends BaseModel {
  final int? _total;
  final List<int> _details = [];

  ReportFullSlotModel.fromJson(Map<String, dynamic> json)
      : _total = json['Total'] {
    if (json['Details'] != null) {
      final jsons = json['Details'];
      if (jsons is List<dynamic>) {
        for (var item in jsons) {
          if (item is int) {
            _details.add(item);
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'Total': _total,
        'Details': _details,
      };

  int? get total => _total;
  List<int> get details => _details;
}