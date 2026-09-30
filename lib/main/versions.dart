part of 'page.dart';

class HandleVersionsCode extends StatelessWidget {
  const HandleVersionsCode({super.key, required this.onVersionSelected});

  final VoidCallback onVersionSelected;

  Future<List<MapEntry<String, Map<String, String>>>> _loadBookLists() async {
    try {
      return Constants.bibleVersionsMap.entries.toList();
    } catch (e) {
      debugPrint('Failed to load book lists: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const tileContentPadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    );
    const leadingSize = 50.0;
    final String activeVersion = Globals.bibleVersionName.toLowerCase();

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.8),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _BottomSheetDragHandle(),
                FutureBuilder<List<MapEntry<String, Map<String, String>>>>(
                  future: _loadBookLists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];
                    return Column(
                      children: items.map((entry) {
                        final key = entry.key.toLowerCase();
                        final name = entry.value['name'] ?? entry.key;
                        final language = entry.value['lang'] ?? 'en';
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: tileContentPadding,
                                leading: Container(
                                  width: leadingSize,
                                  height: leadingSize,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      key.isNotEmpty
                                          ? key[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(name),
                                subtitle: Text(
                                  '${key.toUpperCase()} - $language',
                                ),

                                selected: activeVersion == key,
                                trailing: activeVersion == key
                                    ? Icon(
                                        Icons.check,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : null,
                                onTap: () {
                                  final lang =
                                      Constants
                                          .bibleVersionsMap[key]?['lang'] ??
                                      'en';
                                  Globals.bibleVersionLanguage = lang;
                                  Globals.bibleVersionName = key;
                                  onVersionSelected();
                                  Navigator.pop(context, true);
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}