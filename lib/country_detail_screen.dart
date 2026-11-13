// One request: the country itself, its continent, and its languages.
// $code is a variable, so the same query text works for any country.
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String countryQuery = r'''
  query Country($code: ID!) {
    country(code: $code) {
      name
      emoji
      capital
      currency
      continent {
        name
      }
      languages {
        name
      }
    }
  }
''';

class CountryDetailScreen extends StatelessWidget {
  const new({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(code)),
      body: Query(
        options: QueryOptions(
          document: gql(countryQuery),
          variables: {'code': code},
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final country = result.data?['country'];
          final languages = (country['languages'] as List)
              .map((l) => l['name'])
              .join(', ');
          return ListView(
            children: [
              ListTile(
                title: const Text('Name'),
                subtitle: Text('${country['emoji']} ${country['name']}'),
              ),
              // capital and currency can be null (for example Antarctica)
              ListTile(
                title: const Text('Capital'),
                subtitle: Text(country['capital'] ?? '-'),
              ),
              ListTile(
                title: const Text('Currency'),
                subtitle: Text(country['currency'] ?? '-'),
              ),
              ListTile(
                title: const Text('Continent'),
                subtitle: Text(country['continent']['name']),
              ),
              ListTile(
                title: const Text('Languages'),
                subtitle: Text(languages.isEmpty ? '-' : languages),
              ),
            ],
          );
        },
      ),
    );
  }
}
