import 'package:flutter/material.dart';
import 'package:flutter_graphql_exploration/country_list_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

// The client knows where to send requests (link) and where to keep results (cache).
final ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: HttpLink('https://countries.trevorblades.com/'),
    cache: GraphQLCache(), // in memory only. The README example uses HiveStore for disk.
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(home: Scaffold(body: CountryListScreen())),
    );
  }
}
