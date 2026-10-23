part of 'page.dart';

class HandleVersionsCode extends StatelessWidget {
  const HandleVersionsCode({super.key, required this.onVersionSelected});

  final VoidCallback onVersionSelected;

  static String _formatLanguage(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'eng':
        return 'English';
      case 'lat':
        return 'Latin';
      default:
        return langCode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final activeVersion = Globals.bibleVersionName.toLowerCase();
    final versions = Constants.bibleVersionsMap.entries.toList();

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BottomSheetDragHandle(),
              const SizedBox(height: 4),
              const Text(
                'Bible Versions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Select a translation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: versions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = versions[index];
                    final key = entry.key.toLowerCase();
                    final name = entry.value['name'] ?? entry.key;
                    final rawLang = entry.value['lang'] ?? 'eng';
                    final langDisplay = _formatLanguage(rawLang);
                    final isSelected = activeVersion == key;

                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: isSelected
                          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              key.toUpperCase(),
                              style: TextStyle(
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '$langDisplay (${rawLang.toUpperCase()})',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          final lang =
                              Constants.bibleVersionsMap[key]?['lang'] ?? 'eng';
                          Globals.bibleVersionLanguage = lang;
                          Globals.bibleVersionName = key;
                          onVersionSelected();
                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}