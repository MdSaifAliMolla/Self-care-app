import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  void search() async {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    final results = await provider.searchUsers(_searchController.text);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Friends")),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search by name",
            ),
            onChanged: (_) => search(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final user = searchResults[index];
                return ListTile(
                  title: Text(user['name']),
                  trailing: ElevatedButton(
                    child: Text("Send Request"),
                    onPressed: () {
                      Provider.of<FriendProvider>(context, listen: false)
                          .sendFriendRequest(user['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
