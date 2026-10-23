part of 'page.dart';

enum _MenuAction { bookmarks, selector, books, search }

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _BottomSheetDragHandle(),
                const SizedBox(height: 16),
                _MenuCard(
                  symbol: 'B',
                  title: 'Bookmarks',
                  onTap: () {
                    Globals.type = 1;
                    Navigator.pop(context, _MenuAction.bookmarks);
                  },
                ),
                _MenuCard(
                  symbol: 'B',
                  title: 'Highlights',
                  onTap: () {
                    Globals.type = 2;
                    Navigator.pop(context, _MenuAction.bookmarks);
                  },
                ),
                _MenuCard(
                  symbol: 'S',
                  title: 'Selector',
                  onTap: () => Navigator.pop(context, _MenuAction.selector),
                ),
                _MenuCard(
                  symbol: 'B',
                  title: 'Books',
                  onTap: () => Navigator.pop(context, _MenuAction.books),
                ),
                _MenuCard(
                  symbol: 'S',
                  title: 'Search',
                  onTap: () => Navigator.pop(context, _MenuAction.search),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.symbol,
    required this.title,
    required this.onTap,
  });

  final String symbol;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              symbol,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
