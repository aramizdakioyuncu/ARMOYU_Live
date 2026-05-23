class ServiceResult {
  bool status;
  String description;
  dynamic descriptiondetail;

  ServiceResult({
    this.status = false,
    this.description = '',
    this.descriptiondetail,
  });
}
