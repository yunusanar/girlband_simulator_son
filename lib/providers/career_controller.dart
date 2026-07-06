// Öğrenci No: 202313171033
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import '../domain/game_logic/game_clock.dart';
import '../domain/game_logic/training_manager.dart';

final activeCareerProvider =
    AsyncNotifierProvider<CareerController, PlayerCareer?>(() {
  return CareerController();
});

class CareerController extends AsyncNotifier<PlayerCareer?> {
  @override
  Future<PlayerCareer?> build() async {
    return await ref.read(gameClockProvider).getActiveCareer();
  }

  Future<void> startNewGame(
      {String agencyName = 'Yıldız Ajans',
      int budget = 6000,
      String difficulty = 'medium'}) async {
    state = const AsyncValue.loading();
    final gameClock = ref.read(gameClockProvider);
    await gameClock.startNewCareer(
        agencyName: agencyName, budget: budget, difficulty: difficulty);
    state = AsyncValue.data(await gameClock.getActiveCareer());
  }

  /// Bir hafta ilerletir ve raporu döndürür (UI bildirimi için).
  Future<TrainingReport?> nextWeek() async {
    final currentCareer = state.value;
    if (currentCareer == null) return null;
    final gameClock = ref.read(gameClockProvider);
    final report = await gameClock.advanceWeek(currentCareer);
    state = AsyncValue.data(await gameClock.getActiveCareer());
    return report;
  }
}
