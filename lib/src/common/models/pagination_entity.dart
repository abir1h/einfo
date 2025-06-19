class PaginationEntity<T> {
  final List<T> records;
  final int total;

  PaginationEntity({
    required this.records,
    required this.total,
  }) : assert(T != dynamic);

  factory PaginationEntity.fromJson(
          {required Map<String, dynamic> source,
          required T Function(dynamic item) generateItem}) =>
      PaginationEntity(
        records:
            List<T>.from((source["data"] ?? []).map((x) => generateItem(x))),
        total: source["total"],
      );

  factory PaginationEntity.empty() => PaginationEntity(
        records: [],
        total: -1,
      );
}
