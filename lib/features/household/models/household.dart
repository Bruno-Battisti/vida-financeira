import 'package:freezed_annotation/freezed_annotation.dart';

part 'household.freezed.dart';

@freezed
abstract class Household with _$Household {
  const factory Household({
    required String ownerUid,
    required List<String> memberUids,
  }) = _Household;
}
