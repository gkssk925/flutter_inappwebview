import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';

import '../constants.dart';

void loadUrl() {
  final shouldSkip = !kIsWeb ||
      ![
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);

  testWidgets('reload', (WidgetTester tester) async {
    final Completer controllerCompleter = Completer<InAppWebViewController>();
    final StreamController<String> pageLoads =
    StreamController<String>.broadcast();

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: InAppWebView(
          key: GlobalKey(),
          initialUrlRequest:
          URLRequest(url: Uri.parse('https://github.com/flutter')),
          onWebViewCreated: (controller) {
            controllerCompleter.complete(controller);
          },
          onLoadStop: (controller, url) {
            pageLoads.add(url!.toString());
          },
        ),
      ),
    );
    final InAppWebViewController controller =
    await controllerCompleter.future;
    String? url = await pageLoads.stream.first;
    expect(url, 'https://github.com/flutter');

    await controller.reload();
    url = await pageLoads.stream.first;
    expect(url, 'https://github.com/flutter');

    pageLoads.close();
  });
}
