import 'package:dio/dio.dart';

import 'http_client.dart';
import 'job.dart';

class Api {
  static Future getData() async {
    Response<List<dynamic>> response = await HttpClient.getInstance()!
        .get("job-listing-page-challenge/data.json");
    List<Job>? jobs = response.data?.map((e) => Job.fromJson(e)).toList();
    return jobs;
  }
}
