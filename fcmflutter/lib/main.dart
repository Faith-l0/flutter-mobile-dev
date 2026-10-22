import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

const String vapidKey = 'BLhIVe2KJWJkD_t9JREyClma68Ob-R4KaEm0enUNA3uSUPKBGmWYb8APgveOWUO4Qh6iF99Yp07SeLqJP8w36bw';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _messaging = FirebaseMessaging.instance;
  String _permission = 'Not requested';
  String? _token;
  final List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    final settings = await _messaging.requestPermission();
    setState(() => _permission = settings.authorizationStatus.name);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _messaging.getToken(vapidKey: vapidKey);
      setState(() => _token = token);
    }

    _messaging.onTokenRefresh.listen((token) {
      setState(() => _token = token);
    });

    FirebaseMessaging.onMessage.listen((message) {
      setState(() => _messages.insert(0, message));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Flutter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Permission: $_permission'),
            const SizedBox(height: 12),
            const Text('Registration token:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_token ?? 'No token yet'),
            if (_token != null)
              TextButton.icon(
                onPressed: () => Clipboard.setData(ClipboardData(text: _token!)),
                icon: const Icon(Icons.copy),
                label: const Text('Copy token'),
              ),
            const Divider(height: 32),
            Text('Messages received (${_messages.length})',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text('Nothing yet. Send a test message.'))
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final n = _messages[i].notification;
                        return ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(n?.title ?? '(no title)'),
                          subtitle: Text(n?.body ?? '(no body)'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
