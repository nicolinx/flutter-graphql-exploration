// we only ask for 3 fields. The API has more (capital, currency, ...), but this screen does not need them, so they are not sent.
// `code` is not shown. It is used later to open the detail screen.
import 'package:flutter/material.dart';
import 'package:flutter_graphql_exploration/country_detail_screen.dart';
import 'package:flutter_graphql_exploration/error_example_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String countriesQuery = r'''
  query Countries {
    countries {
      code
      name
      emoji
    }
  }
''';

class CountryListScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ErrorExampleScreen()),
            ),
            icon: Icon(Icons.bug_report),
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(document: gql(countriesQuery)),
        builder: (result, {fetchMore, refetch}) {
          // This builder runs several times: first loading, then data or error.
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List countries = result.data?['countries'] ?? [];
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return ListTile(
                leading: Text(
                  country['emoji'],
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(country['name']),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountryDetailScreen(code: country['code']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
