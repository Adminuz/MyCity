import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';

class CitiesApiService {
  static const String _baseUrl = 'http://94.159.108.34:5000/api/cities';

  Future<List<CityModel>> getCities() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true && responseData['data'] is Map) {
          final dataObject = responseData['data'];

          if (dataObject.containsKey('cities') &&
              dataObject['cities'] is List) {
            final citiesList = dataObject['cities'] as List<dynamic>;

            return citiesList
                .where((city) => city['isActive'] == true)
                .map((city) => CityModel.fromJson(city))
                .toList();
          }
        }
      }

      throw Exception('Faol shaharlar topilmadi');
    } catch (e) {
      rethrow;
    }
  }
}
