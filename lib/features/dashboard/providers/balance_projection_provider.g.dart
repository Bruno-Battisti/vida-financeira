// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_projection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Saldo atual + tudo que já se sabe que vai acontecer nos próximos meses:
/// contas a pagar/receber pendentes (inclui parcelas futuras) e as próximas
/// ocorrências de regras recorrentes ainda não materializadas.

@ProviderFor(balanceProjection)
final balanceProjectionProvider = BalanceProjectionProvider._();

/// Saldo atual + tudo que já se sabe que vai acontecer nos próximos meses:
/// contas a pagar/receber pendentes (inclui parcelas futuras) e as próximas
/// ocorrências de regras recorrentes ainda não materializadas.

final class BalanceProjectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<BalanceProjection>,
          BalanceProjection,
          FutureOr<BalanceProjection>
        >
    with
        $FutureModifier<BalanceProjection>,
        $FutureProvider<BalanceProjection> {
  /// Saldo atual + tudo que já se sabe que vai acontecer nos próximos meses:
  /// contas a pagar/receber pendentes (inclui parcelas futuras) e as próximas
  /// ocorrências de regras recorrentes ainda não materializadas.
  BalanceProjectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'balanceProjectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$balanceProjectionHash();

  @$internal
  @override
  $FutureProviderElement<BalanceProjection> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BalanceProjection> create(Ref ref) {
    return balanceProjection(ref);
  }
}

String _$balanceProjectionHash() => r'575f42363cc0f19e25b6cf5b8d986ceb42fe5d67';
