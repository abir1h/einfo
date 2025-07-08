import '../network/api_service.dart';

mixin AppConstant{
  static int get reloadInSeconds => 5;
  static String getCourseThumbnailUrl(String? thumbnailUrl){
    if(thumbnailUrl != null && thumbnailUrl.isNotEmpty){
      return 'https://api.edupackbd.com/uploads/$thumbnailUrl';
    }else{
      ///Default thumb url
      return "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1902/pavelstasevich190200120/124934975-no-image-available-icon-vector-flat.jpg?ver=6";
    }
  }




}






















