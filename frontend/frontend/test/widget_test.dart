import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('Halaman utama menampilkan judul dan tombol analisis',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AnalisisSentimenApp());

    expect(find.text('Analisis Sentimen Kampus'), findsOneWidget);
    expect(find.text('Analisis Sentimen'), findsOneWidget);
  });
}
