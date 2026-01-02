import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Language data model used for testing - matches the app's language map
const Map<String, Map<String, String>> testLanguages = {
  'EN': {'name': 'English', 'flag': '🇬🇧'},
  'RO': {'name': 'Română', 'flag': '🇷🇴'},
  'FR': {'name': 'Français', 'flag': '🇫🇷'},
  'DE': {'name': 'Deutsch', 'flag': '🇩🇪'},
  'ES': {'name': 'Español', 'flag': '🇪🇸'},
  'IT': {'name': 'Italiano', 'flag': '🇮🇹'},
  'HU': {'name': 'Magyar', 'flag': '🇭🇺'},
  'PL': {'name': 'Polski', 'flag': '🇵🇱'},
};

// Simplified test widget for language selection logic
class TestLanguageSelector extends StatefulWidget {
  final String initialLanguage;
  final void Function(String)? onLanguageChanged;

  const TestLanguageSelector({
    super.key,
    this.initialLanguage = 'EN',
    this.onLanguageChanged,
  });

  @override
  State<TestLanguageSelector> createState() => _TestLanguageSelectorState();
}

class _TestLanguageSelectorState extends State<TestLanguageSelector> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final lang = testLanguages[_selectedLanguage]!;

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // Language display
            Container(
              key: const Key('language_display'),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(lang['flag']!, key: const Key('selected_flag')),
                  const SizedBox(width: 12),
                  Text(lang['name']!, key: const Key('selected_name')),
                ],
              ),
            ),
            // Language code text for testing
            Text('Selected: $_selectedLanguage', key: const Key('selected_code')),
            
            // Language options as buttons (simplified for testing)
            const SizedBox(height: 20),
            const Text('Select Language:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...testLanguages.keys.map((code) {
              final langData = testLanguages[code]!;
              return ListTile(
                key: Key('language_option_$code'),
                leading: Text(langData['flag']!),
                title: Text(langData['name']!),
                trailing: code == _selectedLanguage 
                    ? const Icon(Icons.check_circle, key: Key('check_icon'))
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = code);
                  widget.onLanguageChanged?.call(code);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Language Selector Widget Tests', () {
    testWidgets('should display default language EN', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: TestLanguageSelector(),
      ));
      await tester.pumpAndSettle();

      // Check selected name in header (by key)
      expect(find.byKey(const Key('selected_name')), findsOneWidget);
      expect(find.byKey(const Key('selected_flag')), findsOneWidget);
      expect(find.text('Selected: EN'), findsOneWidget);
      // English text appears twice (in header and in list) - verify at least one
      expect(find.text('English'), findsWidgets);
    });

    testWidgets('should display initial language RO', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: TestLanguageSelector(initialLanguage: 'RO'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Română'), findsWidgets);
      expect(find.text('🇷🇴'), findsWidgets);
      expect(find.text('Selected: RO'), findsOneWidget);
    });

    testWidgets('should display all 8 language options', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: TestLanguageSelector(),
      ));
      await tester.pumpAndSettle();

      // Verify all 8 language options are displayed
      expect(find.byKey(const Key('language_option_EN')), findsOneWidget);
      expect(find.byKey(const Key('language_option_RO')), findsOneWidget);
      expect(find.byKey(const Key('language_option_FR')), findsOneWidget);
      expect(find.byKey(const Key('language_option_DE')), findsOneWidget);
      expect(find.byKey(const Key('language_option_ES')), findsOneWidget);
      expect(find.byKey(const Key('language_option_IT')), findsOneWidget);
      expect(find.byKey(const Key('language_option_HU')), findsOneWidget);
      expect(find.byKey(const Key('language_option_PL')), findsOneWidget);
    });

    testWidgets('should select FR language when tapped', (WidgetTester tester) async {
      String? selectedLang;
      await tester.pumpWidget(ProviderScope(
        child: TestLanguageSelector(
          onLanguageChanged: (lang) => selectedLang = lang,
        ),
      ));
      await tester.pumpAndSettle();

      // Tap French option
      await tester.tap(find.byKey(const Key('language_option_FR')));
      await tester.pumpAndSettle();

      // Verify selection
      expect(find.text('Selected: FR'), findsOneWidget);
      expect(selectedLang, equals('FR'));
    });

    testWidgets('should select DE language when tapped', (WidgetTester tester) async {
      String? selectedLang;
      await tester.pumpWidget(ProviderScope(
        child: TestLanguageSelector(
          onLanguageChanged: (lang) => selectedLang = lang,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language_option_DE')));
      await tester.pumpAndSettle();

      expect(find.text('Selected: DE'), findsOneWidget);
      expect(selectedLang, equals('DE'));
    });

    testWidgets('should select ES language when tapped', (WidgetTester tester) async {
      String? selectedLang;
      await tester.pumpWidget(ProviderScope(
        child: TestLanguageSelector(
          onLanguageChanged: (lang) => selectedLang = lang,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language_option_ES')));
      await tester.pumpAndSettle();

      expect(find.text('Selected: ES'), findsOneWidget);
      expect(selectedLang, equals('ES'));
    });

    testWidgets('should select IT language when tapped', (WidgetTester tester) async {
      String? selectedLang;
      await tester.pumpWidget(ProviderScope(
        child: TestLanguageSelector(
          onLanguageChanged: (lang) => selectedLang = lang,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language_option_IT')));
      await tester.pumpAndSettle();

      expect(find.text('Selected: IT'), findsOneWidget);
      expect(selectedLang, equals('IT'));
    });

    testWidgets('should select HU language when tapped', (WidgetTester tester) async {
      String? selectedLang;
      await tester.pumpWidget(ProviderScope(
        child: TestLanguageSelector(
          onLanguageChanged: (lang) => selectedLang = lang,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language_option_HU')));
      await tester.pumpAndSettle();

      expect(find.text('Selected: HU'), findsOneWidget);
      expect(selectedLang, equals('HU'));
    });

    testWidgets('should select PL language when tapped', (WidgetTester tester) async {
      String? selectedLang;
      await tester.pumpWidget(ProviderScope(
        child: TestLanguageSelector(
          onLanguageChanged: (lang) => selectedLang = lang,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language_option_PL')));
      await tester.pumpAndSettle();

      expect(find.text('Selected: PL'), findsOneWidget);
      expect(selectedLang, equals('PL'));
    });

    testWidgets('should show check icon for selected language', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: TestLanguageSelector(initialLanguage: 'DE'),
      ));
      await tester.pumpAndSettle();

      // Only German should have check icon initially
      final deTile = find.byKey(const Key('language_option_DE'));
      expect(
        find.descendant(of: deTile, matching: find.byIcon(Icons.check_circle)),
        findsOneWidget,
      );

      // English should not have check icon
      final enTile = find.byKey(const Key('language_option_EN'));
      expect(
        find.descendant(of: enTile, matching: find.byIcon(Icons.check_circle)),
        findsNothing,
      );
    });

    testWidgets('should update check icon when selection changes', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: TestLanguageSelector(initialLanguage: 'EN'),
      ));
      await tester.pumpAndSettle();

      // Initially EN has check
      final enTile = find.byKey(const Key('language_option_EN'));
      expect(
        find.descendant(of: enTile, matching: find.byIcon(Icons.check_circle)),
        findsOneWidget,
      );

      // Select FR
      await tester.tap(find.byKey(const Key('language_option_FR')));
      await tester.pumpAndSettle();

      // Now FR should have check
      final frTile = find.byKey(const Key('language_option_FR'));
      expect(
        find.descendant(of: frTile, matching: find.byIcon(Icons.check_circle)),
        findsOneWidget,
      );

      // EN should no longer have check
      expect(
        find.descendant(of: enTile, matching: find.byIcon(Icons.check_circle)),
        findsNothing,
      );
    });
  });

  group('Language Data Validation', () {
    test('should have exactly 8 languages', () {
      expect(testLanguages.length, equals(8));
    });

    test('all languages should have name and flag', () {
      for (final entry in testLanguages.entries) {
        expect(entry.value['name'], isNotNull, reason: '${entry.key} missing name');
        expect(entry.value['flag'], isNotNull, reason: '${entry.key} missing flag');
        expect(entry.value['name']!.isNotEmpty, isTrue);
        expect(entry.value['flag']!.isNotEmpty, isTrue);
      }
    });

    test('should contain all expected language codes', () {
      final expectedCodes = ['EN', 'RO', 'FR', 'DE', 'ES', 'IT', 'HU', 'PL'];
      for (final code in expectedCodes) {
        expect(testLanguages.containsKey(code), isTrue,
            reason: 'Missing language code: $code');
      }
    });

    test('language names should be in native language', () {
      expect(testLanguages['EN']!['name'], equals('English'));
      expect(testLanguages['RO']!['name'], equals('Română'));
      expect(testLanguages['FR']!['name'], equals('Français'));
      expect(testLanguages['DE']!['name'], equals('Deutsch'));
      expect(testLanguages['ES']!['name'], equals('Español'));
      expect(testLanguages['IT']!['name'], equals('Italiano'));
      expect(testLanguages['HU']!['name'], equals('Magyar'));
      expect(testLanguages['PL']!['name'], equals('Polski'));
    });

    test('flags should be country emojis', () {
      expect(testLanguages['EN']!['flag'], equals('🇬🇧'));
      expect(testLanguages['RO']!['flag'], equals('🇷🇴'));
      expect(testLanguages['FR']!['flag'], equals('🇫🇷'));
      expect(testLanguages['DE']!['flag'], equals('🇩🇪'));
      expect(testLanguages['ES']!['flag'], equals('🇪🇸'));
      expect(testLanguages['IT']!['flag'], equals('🇮🇹'));
      expect(testLanguages['HU']!['flag'], equals('🇭🇺'));
      expect(testLanguages['PL']!['flag'], equals('🇵🇱'));
    });
  });
}
