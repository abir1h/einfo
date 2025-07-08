class UserSession {
  final String tokenType;
  final String token;
  final User user;

  UserSession({
    required this.tokenType,
    required this.token,
    required this.user,
  });

  // Empty constructor with default values
  factory UserSession.empty() => UserSession(
        tokenType: "",
        token: "",
        user: User.empty(),
      );

  // Factory method to create UserSession from JSON
  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
        tokenType: json["token_type"] ?? "",
        token: json["token"] ?? "",
        user: json["user"] != null ? User.fromJson(json["user"]) : User.empty(),
      );

  // Convert UserSession to JSON
  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "token": token,
        "user": user.toJson(),
      };

  bool get isEmpty => token.isEmpty;
}

class User {
  final int id;
  final String name;
  final String email;
  final String username;
  final String referralCode;
  final String referredCode;
  final String tutorCode;
  final String primaryNumber;
  final String alternateNumber;
  String profileImage;
  final String dateOfBirth;
  final String religion;
  final String fathersName;
  final String mothersName;
  final String fatherNumber;
  final String motherNumber;
  final String gender;
  final String maritalStatus;
  final String bloodGroup;
  final String bio;
  final String parentId;
  final String classId;
  final String presentDivisionId;
  final String presentDistrictId;
  final String presentAreaId;
  final String presentAddress;
  final String permanentDivisionId;
  final String permanentDistrictId;
  final String permanentAreaId;
  final String permanentAddress;
  final String organizationId;
  final bool isActive;
  final bool isKid;
  final bool isAccountVerified;
  final bool isForeigner;
  final bool isBacbonCertified;
  final UserType userType;
  final String deviceId;
  final String fcmId;
  final String nidNo;
  final String birthCertificateNo;
  final String profession;
  final String passportNo;
  final String introVideo;
  final String bacbonRank;
  final int profileProgress;
  final String emailVerifiedAt;
  final String createdBy;
  final bool isPasswordSet;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.referralCode,
    required this.referredCode,
    required this.tutorCode,
    required this.primaryNumber,
    required this.alternateNumber,
    required this.profileImage,
    required this.dateOfBirth,
    required this.religion,
    required this.fathersName,
    required this.mothersName,
    required this.fatherNumber,
    required this.motherNumber,
    required this.gender,
    required this.maritalStatus,
    required this.bloodGroup,
    required this.bio,
    required this.parentId,
    required this.classId,
    required this.presentDivisionId,
    required this.presentDistrictId,
    required this.presentAreaId,
    required this.presentAddress,
    required this.permanentDivisionId,
    required this.permanentDistrictId,
    required this.permanentAreaId,
    required this.permanentAddress,
    required this.organizationId,
    required this.isActive,
    required this.isKid,
    required this.isAccountVerified,
    required this.isForeigner,
    required this.isBacbonCertified,
    required this.userType,
    required this.deviceId,
    required this.fcmId,
    required this.nidNo,
    required this.birthCertificateNo,
    required this.profession,
    required this.passportNo,
    required this.introVideo,
    required this.bacbonRank,
    required this.profileProgress,
    required this.emailVerifiedAt,
    required this.createdBy,
    required this.isPasswordSet,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Empty constructor with default values
  factory User.empty() => User(
        id: -1,
        name: "",
        email: "",
        username: "",
        referralCode: "",
        referredCode: "",
        tutorCode: "",
        primaryNumber: "",
        alternateNumber: "",
        profileImage: "",
        dateOfBirth: "",
        religion: "",
        fathersName: "",
        mothersName: "",
        fatherNumber: "",
        motherNumber: "",
        gender: "Other",
        maritalStatus: "",
        bloodGroup: "",
        bio: "",
        parentId: "",
        classId: "",
        presentDivisionId: "",
        presentDistrictId: "",
        presentAreaId: "",
        presentAddress: "",
        permanentDivisionId: "",
        permanentDistrictId: "",
        permanentAreaId: "",
        permanentAddress: "",
        organizationId: "",
        isActive: true,
        isKid: false,
        isAccountVerified: false,
        isForeigner: false,
        isBacbonCertified: false,
        userType: UserType.guest,
        deviceId: "",
        fcmId: "",
        nidNo: "",
        birthCertificateNo: "",
        profession: "",
        passportNo: "",
        introVideo: "",
        bacbonRank: "",
        profileProgress: -1,
        emailVerifiedAt: "",
        createdBy: "",
        isPasswordSet: true,
        deletedAt: "",
        createdAt: "",
        updatedAt: "",
      );

  // Factory method to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? -1,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        username: json["username"] ?? "",
        referralCode: json["referral_code"] ?? "",
        referredCode: json["referred_code"] ?? "",
        tutorCode: json["tutor_code"] ?? "",
        primaryNumber: json["primary_number"] ?? "",
        alternateNumber: json["alternate_number"] ?? "",
        profileImage: json["profile_image"] ?? "",
        dateOfBirth: json["date_of_birth"] ?? "",
        religion: json["religion"] ?? "",
        fathersName: json["fathers_name"] ?? "",
        mothersName: json["mothers_name"] ?? "",
        fatherNumber: json["father_number"] ?? "",
        motherNumber: json["mothar_number"] ?? "",
        gender: json["gender"] ?? "Other",
        maritalStatus: json["marital_status"] ?? "",
        bloodGroup: json["blood_group"] ?? "",
        bio: json["bio"] ?? "",
        parentId: json["parent_id"] ?? "",
        classId: json["class_id"] ?? "",
        presentDivisionId: json["present_division_id"] ?? "",
        presentDistrictId: json["present_district_id"] ?? "",
        presentAreaId: json["present_area_id"] ?? "",
        presentAddress: json["present_address"] ?? "",
        permanentDivisionId: json["permanent_division_id"] ?? "",
        permanentDistrictId: json["permanent_district_id"] ?? "",
        permanentAreaId: json["permanent_area_id"] ?? "",
        permanentAddress: json["permanent_address"] ?? "",
        organizationId: json["organization_id"] ?? "",
        isActive: json["is_active"] ?? true,
        isKid: json["is_kid"] ?? false,
        isAccountVerified: json["is_account_verified"] ?? false,
        isForeigner: json["is_foreigner"] ?? false,
        isBacbonCertified: json["is_bacbon_certified"] ?? false,
        userType: json["user_type"]
            == "Teacher"
            ? UserType.teacher
            : json["user_type"] == "Student"
                ? UserType.student
                : json["user_type"] == "Guardian"
                    ? UserType.guardian
                    : UserType.guest,
        deviceId: json["device_id"] ?? "",
        fcmId: json["fcm_id"] ?? "",
        nidNo: json["nid_no"] ?? "",
        birthCertificateNo: json["birth_certificate_no"] ?? "",
        profession: json["profession"] ?? "",
        passportNo: json["passport_no"] ?? "",
        introVideo: json["intro_video"] ?? "",
        bacbonRank: json["bacbon_rank"] ?? "",
        profileProgress: json["profile_progress"] ?? -1,
        emailVerifiedAt: json["email_verified_at"] ?? "",
        createdBy: json["created_by"] ?? "",
        isPasswordSet: json["is_password_set"] ?? true,
        deletedAt: json["deleted_at"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  // Convert User to JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
        "referral_code": referralCode,
        "referred_code": referredCode,
        "tutor_code": tutorCode,
        "primary_number": primaryNumber,
        "alternate_number": alternateNumber,
        "profile_image": profileImage,
        "date_of_birth": dateOfBirth,
        "religion": religion,
        "fathers_name": fathersName,
        "mothers_name": mothersName,
        "father_number": fatherNumber,
        "mothar_number": motherNumber,
        "gender": gender,
        "marital_status": maritalStatus,
        "blood_group": bloodGroup,
        "bio": bio,
        "parent_id": parentId,
        "class_id": classId,
        "present_division_id": presentDivisionId,
        "present_district_id": presentDistrictId,
        "present_area_id": presentAreaId,
        "present_address": presentAddress,
        "permanent_division_id": permanentDivisionId,
        "permanent_district_id": permanentDistrictId,
        "permanent_area_id": permanentAreaId,
        "permanent_address": permanentAddress,
        "organization_id": organizationId,
        "is_active": isActive,
        "is_kid": isKid,
        "is_account_verified": isAccountVerified,
        "is_foreigner": isForeigner,
        "is_bacbon_certified": isBacbonCertified,
        "user_type": userType.toName(),
        "device_id": deviceId,
        "fcm_id": fcmId,
        "nid_no": nidNo,
        "birth_certificate_no": birthCertificateNo,
        "profession": profession,
        "passport_no": passportNo,
        "intro_video": introVideo,
        "bacbon_rank": bacbonRank,
        "profile_progress": profileProgress,
        "email_verified_at": emailVerifiedAt,
        "created_by": createdBy,
        "is_password_set": isPasswordSet,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}


enum UserType {
  teacher,
  student,
  guardian,
  guest;

  String toName() {
    switch (this) {
      case UserType.guardian:
        return "Guardian";
      case UserType.teacher:
        return "Teacher";
      case UserType.student:
        return "Student";
      default:
        return "none";
    }
  }

  static fromName(String name) {
    switch (name) {
      case "Guardian":
        return UserType.guardian;
      case "Teacher":
        return UserType.teacher;
      case "Student":
        return UserType.student;
      default:
        return UserType.guest;
    }
  }
}


// class UserSession {
//   final int id;
//   final String name;
//   final String email;
//   final String username;
//   final String contactNo;
//   final int organizationId;
//   final String address;
//   final String image;
//   final String token;
//   bool isOnboarded;
//
//   UserSession(
//       {required this.id,
//       required this.name,
//       required this.email,
//       required this.username,
//       required this.contactNo,
//       required this.organizationId,
//       required this.address,
//       required this.token,
//       required this.image,
//       this.isOnboarded = false});
//
//   factory UserSession.empty() => UserSession(
//       id: -1,
//       name: "",
//       email: "",
//       username: "",
//       contactNo: "",
//       organizationId: -1,
//       address: "",
//       token: "",
//       image: "",
//       isOnboarded: true);
//
//   factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
//         id: json["id"] ?? -1,
//         name: json["name"] ?? "",
//         email: json["email"] ?? "",
//         username: json["username"] ?? "",
//         contactNo: json["contact_no"] ?? "",
//         organizationId: json["organization_id"] ?? -1,
//         address: json["address"] ?? "",
//         token: json["token"] ?? "",
//         image: json["image"] ?? "",
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "username": username,
//         "contact_no": contactNo,
//         "organization_id": organizationId,
//         "address": address,
//         "token": token,
//         "image": image
//       };
//
//   bool get isEmpty => token.isEmpty;
// }
