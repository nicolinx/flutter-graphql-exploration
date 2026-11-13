// `nope` does not exist on Country, so the server rejects this query.
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String badQuery = r'''
  query Bad {
    countries {
      code
      nope
    }
  }
''';

class ErrorExampleScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ErrorExampleScreen> createState() => _ErrorExampleScreenState();
}

class _ErrorExampleScreenState extends State<ErrorExampleScreen> {
  String tryCatchResult = 'not run yet';

  // Part 2: call the client directly inside try/catch.
  Future<void> runWithTryCatch() async {
    final client = GraphQLProvider.of(context).value;
    try {
      final result = await client.query(QueryOptions(document: gql(badQuery)));
      setState(
        () => tryCatchResult =
            'try block finished, catch did NOT run. result.hasException = ${result.hasException}',
      );
    } catch (e) {
      setState(() => tryCatchResult = 'catch ran: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error example')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '1. Query widget',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Query(
            options: QueryOptions(document: gql(badQuery)),
            builder:
                (
                  QueryResult result, {
                  VoidCallback? refetch,
                  FetchMore? fetchMore,
                }) {
                  if (result.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (result.hasException) {
                    // The messages sent by the server are in graphqlErrors.
                    final messages = result.exception!.graphqlErrors
                        .map((e) => e.message)
                        .join('\n');
                    return Text('hasException = true\n$messages');
                  }
                  return const Text('no error (unexpected)');
                },
          ),
          const SizedBox(height: 24),
          const Text(
            '2. client.query inside try/catch',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(onPressed: runWithTryCatch, child: const Text('Run')),
          Text(tryCatchResult),
        ],
      ),
    );
  }
}
