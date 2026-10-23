part of 'page.dart';

class HandleBookListCode extends StatefulWidget {
  const HandleBookListCode({super.key});

  @override
  HandleBookListState createState() => HandleBookListState();
}

class HandleBookListState extends State<HandleBookListCode> {
  List<BookList> _items = [];
  bool _loading = true;

  String get _activeVersion => Globals.bibleVersionName.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final allItems = await isar.bookLists.where().findAll();
      if (!mounted) return;
      setState(() => _items = allItems);
    } catch (_) {
      if (mounted) setState(() => _items = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleActive(int index, bool value) async {
    final original = _items[index].active;
    final messenger = ScaffoldMessenger.of(context);

    // Optimistic UI update
    setState(() => _items[index].active = value);

    try {
      await isar.writeTxn(() async {
        await isar.bookLists.put(_items[index]);
      });
    } catch (e) {
      if (mounted) {
        setState(() => _items[index].active = original);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

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
                'Manage Translations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Toggle visibility in selectors and comparison tools',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: _loading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No translations found',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          final isCurrentActive =
                              item.abbr.trim().toLowerCase() == _activeVersion;

                          return Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: SwitchListTile.adaptive(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  _formatSubtitle(item, isCurrentActive),
                                  style: TextStyle(
                                    color: isCurrentActive
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: isCurrentActive
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              secondary: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isCurrentActive
                                      ? colorScheme.primaryContainer
                                      : colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    item.abbr.toUpperCase(),
                                    style: TextStyle(
                                      color: isCurrentActive
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              value: item.active,
                              activeTrackColor: colorScheme.primary,
                              onChanged: isCurrentActive
                                  ? null
                                  : (value) => _toggleActive(index, value),
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

  String _formatSubtitle(BookList item, bool isCurrentActive) {
    final base = '${item.abbr.toUpperCase()} · ${item.language.toUpperCase()}';
    return isCurrentActive ? '$base · Active Version (Cannot Disable)' : base;
  }
}
