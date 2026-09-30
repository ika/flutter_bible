part of 'page.dart';

enum _MenuAction { bookmarks, selector, search }

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

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
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
                          'B',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Bookmarks'),
                    onTap: () {
                      Globals.type = 1;
                      Navigator.pop(context, _MenuAction.bookmarks);
                    },
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
                          'B',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Highlights'),
                    onTap: () {
                      Globals.type = 2;
                      Navigator.pop(context, _MenuAction.bookmarks);
                    },
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
                          'S',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Selector'),
                    onTap: () {
                      Navigator.pop(context, _MenuAction.selector);
                    },
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
                          'S',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Search'),
                    onTap: () {
                      Navigator.pop(context, _MenuAction.search);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
