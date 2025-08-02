import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../models/weather_model.dart';
import '../models/prayer_time_model.dart';

class MainApiResponse {
  final List<EventModel> events;
  final WeatherModel weather;
  final List<PrayerTime> prayerTimes;

  MainApiResponse({
    required this.events,
    required this.weather,
    required this.prayerTimes,
  });
}

class MainApiService {
  static const String _baseApiUrl = 'http://94.159.108.34:5000/api';
  final String infoEndpoint = '$_baseApiUrl/info/';
  final String eventsEndpoint = '$_baseApiUrl/events/';

  Future<MainApiResponse> fetchAll({String? city}) async {
    String infoUrl = infoEndpoint;
    if (city != null && city.isNotEmpty) {
      infoUrl += Uri.encodeComponent(city);
    }

    String eventsUrl = eventsEndpoint;
    if (city != null && city.isNotEmpty) {
      eventsUrl += Uri.encodeComponent(city);
    }

    try {
      final responses = await Future.wait([
        http.get(Uri.parse(infoUrl)),
        http.get(Uri.parse(eventsUrl)),
      ]);

      final infoResponse = responses[0];
      final eventsResponse = responses[1];

      final mainData = await _processInfoResponse(infoResponse);
      final events = await _processEventsResponse(eventsResponse);

      return MainApiResponse(
        events: events,
        weather: mainData['weather'],
        prayerTimes: mainData['prayerTimes'],
      );
    } catch (e) {
      throw Exception('Ma\'lumotlarni yuklashda xatolik: $e');
    }
  }

  Future<Map<String, dynamic>> _processInfoResponse(
    http.Response response,
  ) async {
    if (response.statusCode != 200) {
      throw Exception(
        'Asosiy ma\'lumotlarni yuklashda xatolik: ${response.statusCode}',
      );
    }

    final responseData = json.decode(response.body);

    if (responseData['success'] != true) {
      throw Exception('API noto\'g\'ri javob qaytardi');
    }

    final data = responseData['data'];

    final weatherData = data['weather'];
    final weather = WeatherModel(
      temperature: weatherData['temperature'] ?? 0,
      description: weatherData['description'] ?? '',
    );

    final prayerTimesData = data['prayerTimes'];
    List<PrayerTime> prayerTimes = [];

    if (prayerTimesData is List) {
      prayerTimes = prayerTimesData
          .map((e) => PrayerTime(name: e['name'] ?? '', time: e['time'] ?? ''))
          .toList();
    }

    return {'weather': weather, 'prayerTimes': prayerTimes};
  }

  Future<List<EventModel>> _processEventsResponse(
    http.Response response,
  ) async {
    if (response.statusCode != 200) {
      return [];
    }

    try {
      final responseData = json.decode(response.body);

      if (responseData is List) {
        return _parseEventsList(responseData);
      }

      if (responseData is Map &&
          responseData['success'] == true &&
          responseData['data'] is Map) {
        final dataObject = responseData['data'];

        if (dataObject.containsKey('events') && dataObject['events'] is List) {
          return _parseEventsList(dataObject['events']);
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  List<EventModel> _parseEventsList(List<dynamic> eventsList) {
    return eventsList.map((e) => EventModel.fromJson(e)).toList();
  }
}
