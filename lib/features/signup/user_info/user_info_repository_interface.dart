abstract class UserInfoRepository {
  Future<String> submitUserDetails(
    String name,
    String dob,
    String address,
    String email,
  );
}
