import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/household/repositories/households_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late HouseholdsRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = HouseholdsRepository(firestore);
  });

  test('ensureHousehold cria um household solo para um usuário novo', () async {
    await repository.ensureHousehold('user-1');

    final household = await repository.watchMyHousehold('user-1').first;
    expect(household, isNotNull);
    expect(household!.ownerUid, 'user-1');
    expect(household.memberUids, ['user-1']);
  });

  test('ensureHousehold não cria um segundo household se já existe um', () async {
    await repository.ensureHousehold('user-1');
    await repository.ensureHousehold('user-1');

    final household = await repository.watchMyHousehold('user-1').first;
    expect(household!.memberUids, ['user-1']);
  });

  test('join() adiciona o usuário ao household de outra pessoa e apaga o próprio household solo', () async {
    await repository.ensureHousehold('owner');
    await repository.ensureHousehold('member');

    await repository.join(myUid: 'member', inviteCode: 'owner');

    final ownerHousehold = await repository.watchMyHousehold('owner').first;
    expect(ownerHousehold!.memberUids, containsAll(['owner', 'member']));

    final memberHousehold = await repository.watchMyHousehold('member').first;
    expect(memberHousehold!.ownerUid, 'owner');
  });

  test('join() com código inválido lança erro', () async {
    await repository.ensureHousehold('member');

    expect(
      () => repository.join(myUid: 'member', inviteCode: 'codigo-que-nao-existe'),
      throwsException,
    );
  });

  test('leave() sai do household compartilhado e volta a ter um household solo', () async {
    await repository.ensureHousehold('owner');
    await repository.ensureHousehold('member');
    await repository.join(myUid: 'member', inviteCode: 'owner');

    await repository.leave('member');

    final ownerHousehold = await repository.watchMyHousehold('owner').first;
    expect(ownerHousehold!.memberUids, ['owner']);

    final memberHousehold = await repository.watchMyHousehold('member').first;
    expect(memberHousehold!.ownerUid, 'member');
  });
}
