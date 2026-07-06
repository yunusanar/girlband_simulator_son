// Öğrenci No: 202313171033
import '../../data/database/app_database.dart';

/// Mali işlem defteri: her para hareketini Transactions tablosuna yazar.
/// absMonth, kariyerin o anki takvim durumundan türetilir (aksiyonlar o ayın
/// haftalarında, aylık ekonomi ise ayı kapatırken kaydedilir).
class Ledger {
  static Future<void> record(
    AppDatabase db,
    int careerId,
    String category,
    String label,
    int amount,
  ) async {
    if (amount == 0) return;
    final c = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (c == null) return;
    final absMonth = (c.currentYear - 1) * 12 + c.currentMonth;
    await db.into(db.transactions).insert(TransactionsCompanion.insert(
          careerId: careerId,
          absMonth: absMonth,
          displayMonth: c.currentMonth,
          year: c.currentYear,
          category: category,
          label: label,
          amount: amount,
        ));
  }
}
