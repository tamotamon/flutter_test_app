import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .envを読み込めるように設定.
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.get('VAR_URL'), // .envのURLを取得.
    anonKey: dotenv.get('VAR_ANONKEY'), // .envのanonキーを取得.
   );
  runApp(FlutterTestApp());
}

class FlutterTestApp extends StatelessWidget {
  const FlutterTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CarMaintenace',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client
      .from('t_car_maintenance')
      .select(); // Correct: List of strings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final t_car_maintenance = snapshot.data!;
          return ListView.builder(
            itemCount: t_car_maintenance.length,
            itemBuilder: ((context, index) {
              final car_mainte = t_car_maintenance[index];
              final price = car_mainte['price'] as int; // Assuming price is integer
              return ListTile(
                title: Text(car_mainte['content']),
                subtitle: Text('Price: $price'),
              );
            }),
          );
        },
      ),
    );
  }
}
