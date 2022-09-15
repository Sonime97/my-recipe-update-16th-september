import 'package:flutter/material.dart';
import '../blogdetailbackup.dart';
class CustomSearchDelegate extends SearchDelegate {
   final ids;
   final recipesThem; 
   
  CustomSearchDelegate({required this.recipesThem, required this.ids});
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<String> matchQuery = [];
    for (var fruit in recipesThem) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(''),
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in recipesThem) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          child: ListTile(
            title: Text(result),
           
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
                                            BlogDetail.routeName,
                                            arguments: ids[index],
                                          );

          } 
        );
      },
    );
  }
  
}