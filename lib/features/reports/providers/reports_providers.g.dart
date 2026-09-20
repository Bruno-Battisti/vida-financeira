// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportsData)
final reportsDataProvider = ReportsDataProvider._();

final class ReportsDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReportsData>,
          ReportsData,
          FutureOr<ReportsData>
        >
    with $FutureModifier<ReportsData>, $FutureProvider<ReportsData> {
  ReportsDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsDataHash();

  @$internal
  @override
  $FutureProviderElement<ReportsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReportsData> create(Ref ref) {
    return reportsData(ref);
  }
}

String _$reportsDataHash() => r'1c8d10f769af714e6adab131431388eb6980027c';
