import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarAwesome extends StatefulWidget {
  const SearchBarAwesome({super.key});

  @override
  State<SearchBarAwesome> createState() => _SearchBarAwesomeState();
}

class _SearchBarAwesomeState extends State<SearchBarAwesome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search bar"),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: CustomSearchDelegate());
          }, icon: const Icon(Icons.search))
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate{
  List<String> searchTerms = [
    'Apple',
    'Banana',
    'Pear',
    'Orange',
    'Watemelon',
    'Strawberry',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query = 'Pear';
      }, icon: const Icon(Icons.search))
    ];
  }

  // @override
  // Widget? buildLeading(BuildContext context) {
  //   return IconButton(onPressed: (){
  //     close(context, null);
  //   }, icon: const Icon(Icons.arrow_back));
  // }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];

    for (var fruit in searchTerms){
      if(fruit.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(fruit);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index){
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: (){
            print("hallooooo");
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];

    for (var fruit in searchTerms){
      if(fruit.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(fruit);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index){
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: (){
            print("hallooooo");
          },
        );
      },
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Container();
  }
}