import 'package:bible/translate/service.dart';
import 'package:flutter/material.dart';

final translator = TranslationService();

Future<String> translateText(String input) async {
  final response = await translator.translateLatinToEnglish(input);
  return response.isNotEmpty ? response : 'Response returned empty';
}

class TranslationDialog extends StatefulWidget {
  const TranslationDialog({
    super.key,
    required this.verseText,
    required this.reference,
  });

  final String verseText;
  final String reference;

  @override
  State<TranslationDialog> createState() => _TranslationDialogState();
}

class _TranslationDialogState extends State<TranslationDialog> {
  late Future<String> _translationFuture;

  @override
  void initState() {
    super.initState();
    _translationFuture = translateText(widget.verseText);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(Icons.translate, color: colorScheme.primary),
      title: Text(
        widget.reference,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Original (Latin):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.verseText,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Translation (English):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: _translationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: colorScheme.error),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      snapshot.data ?? 'No translation',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  } else {
                    return Text(
                      'No translation available',
                      style: TextStyle(color: colorScheme.outline),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        // TextButton(
        //   onPressed: () {
        //     final fullText = '${widget.verseText} (${widget.reference})';
        //     Clipboard.setData(ClipboardData(text: fullText));
        //     ScaffoldMessenger.of(
        //       context,
        //     ).showSnackBar(const SnackBar(content: Text('Translation copied')));
        //   },
        //   child: const Text('Copy'),
        // ),
      ],
    );
  }
}
