enum KycAuthenticationModel {
  Success,
  Failure,
  // Pending
}

List<String> authenticationList = KycAuthenticationModel.values
    .map((e) => e.toString().split(".")[1])
    .toList();
