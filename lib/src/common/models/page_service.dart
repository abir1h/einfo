import 'dart:async';

class ServiceState {
  String searchTerm = "";
  bool thisWeek = false;
  bool thisMonth = false;
  bool active = false;
  bool dateExpired = false;
  String divisionId='';
  String districtId='';
  String upazilaId='';
  String areaIds='';
  String mediumIds='';
  String classIds='';
  String subjectIds='';
  String instituteIds='';
  String gender='';
  String tuitionType='offline';
  String salaryAmmount='';
  String negotiable='';

  String unionId = '';
  int pageSize = 10;
  int pageNumber = 1;
  int totalPage = 0;

  ///Search and category filter stream controller
  final StreamController<bool> _searchActivityStreamController =
      StreamController.broadcast();

  ///Streams
  Stream<bool> get searchActivityStream =>
      _searchActivityStreamController.stream;

  void addToSearchActivityStream(bool value) {
    if (!_searchActivityStreamController.isClosed) {
      _searchActivityStreamController.sink.add(value);
    }
  }

  void dispose() {
    _searchActivityStreamController.close();
  }

  // String get getPaginatedUrlSegment => "name=$searchTerm&categoryId=${selectedCategory.id > 0?selectedCategory.id:""}&size=$pageSize&pageNumber=$pageNumber";
  // String getPaginatedAndFilteredUrlSegment(int pageSize, int pageNumber) => "name=$searchTerm&categoryId=${selectedCategory.id > 0?selectedCategory.id:""}&size=$pageSize&pageNumber=$pageNumber";
  String getPaginatedUrlSegment(
    int pageSize,
    int pageNumber,
  ) =>
      "page=$pageNumber&page_size=$pageSize";

  String getPaginatedAndFilterUrlSegment(int pageNumber) {
    List<String> filters = [];

    filters.add("page=$pageNumber");

    if (searchTerm.isNotEmpty) filters.add("search=$searchTerm");
    if (thisWeek) filters.add("this_week=1");
    if (thisMonth) filters.add("this_month=1");

    return "?${filters.join("&")}";
  }


  String getPaginatedUrlSegmentForFeedback(
    String videoId,
    int pageSize,
    int pageNumber,
  ) =>
      "$videoId/?page=$pageNumber&page_size=$pageSize";
  String getPaginatedFindTutionUrlSegment(int pageNumber) {
    List<String> filters = [];

    if (searchTerm.isNotEmpty) filters.add("search=$searchTerm");
    if(thisMonth)filters.add("this_month=1");
    if(thisWeek)filters.add("this_week=1");
    if (divisionId.isNotEmpty) filters.add("division_id=$divisionId");
    if (districtId.isNotEmpty) filters.add("district_id=$districtId");
    if (upazilaId.isNotEmpty) filters.add("upazila_id=$upazilaId");
    if (areaIds.isNotEmpty) filters.add("area_ids=$areaIds");
    if (mediumIds.isNotEmpty) filters.add("medium_ids=$mediumIds");
    if (classIds.isNotEmpty) filters.add("class_ids=$classIds");
    if (subjectIds.isNotEmpty) filters.add("subject_ids=$subjectIds");
    if (instituteIds.isNotEmpty) filters.add("institute_ids=$instituteIds");
    if (gender.isNotEmpty) filters.add("gender=$gender");
    if (tuitionType.isNotEmpty) filters.add("tuition_type=$tuitionType");
    if (salaryAmmount.isNotEmpty && negotiable != '1') {
      filters.add("salary_amount=$salaryAmmount");
    }

    if (negotiable.isNotEmpty) filters.add("negotiable=$negotiable");

    String filterString = filters.isNotEmpty ? "&${filters.join("&")}" : "";

    return "?page=$pageNumber$filterString";
  }
  String getPaginatedFindTutorUrlSegment(int pageNumber) {
    List<String> filters = [];

    if (searchTerm.isNotEmpty) filters.add("search=$searchTerm");
    if (divisionId.isNotEmpty) filters.add("division_id=$divisionId");
    if (districtId.isNotEmpty) filters.add("district_id=$districtId");
    if (upazilaId.isNotEmpty) filters.add("upazila_id=$upazilaId");
    if (unionId.isNotEmpty) filters.add("union_id=$unionId"); // Using 'union_id' here
    if (mediumIds.isNotEmpty) filters.add("medium_ids=$mediumIds");
    if (classIds.isNotEmpty) filters.add("grade_ids=$classIds");
    if (subjectIds.isNotEmpty) filters.add("subject_ids=$subjectIds");
    if (instituteIds.isNotEmpty) filters.add("institute_ids=$instituteIds");
    if (gender.isNotEmpty) filters.add("gender=$gender");
    if (tuitionType.isNotEmpty) filters.add("is_online=${tuitionType=="offline"?"0":"1"}");
    if (salaryAmmount.isNotEmpty && negotiable != '1') {
      filters.add("fee=$salaryAmmount");
    }

    if (negotiable.isNotEmpty) filters.add("negotiable=$negotiable");

    String filterString = filters.isNotEmpty ? "&${filters.join("&")}" : "";

    return "?page=$pageNumber$filterString";
  }
}

