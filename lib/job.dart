class Job {
  final String position;
  final String timing;
  final String location;
  final List<dynamic>? keywords;
  final String company;
  final String companyLogo;
  final DateTime postedOn;

  Job(this.position, this.timing, this.location, this.keywords, this.company,
      this.companyLogo, this.postedOn);

  Job.fromJson(Map<String, dynamic> json)
      : position = json['position'],
        timing = json['timing'],
        location = json['location'],
        keywords = json['keywords'],
        company = json['company'],
        companyLogo = json['company_logo'],
        postedOn =
            DateTime.fromMicrosecondsSinceEpoch(json['posted_on'] * 1000);

  @override
  String toString() {
    return "position: $position, company: $company, posted_on: $postedOn";
  }
}
