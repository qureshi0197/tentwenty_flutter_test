import 'package:dio/dio.dart';

class TMDBClient {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyM2I5YTQ0MmNmMjQ5NmQxMzg5ZjE3MDFkMzEwY2M3NSIsIm5iZiI6MTc2OTY4NzQ4NC4zMzEsInN1YiI6IjY5N2I0OWJjODUxMTY1ZDA3ZWEwOGRhMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2F1yhdUw7GpTOyQfJuxcpDizipFwmFtHm187LgzcTlI';

  late final Dio dio;

  TMDBClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Authorization': 'Bearer $bearerToken', 'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }
}
