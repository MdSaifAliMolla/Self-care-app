import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/screens/search.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';

class Ping extends StatefulWidget {
  @override
  _PingState createState() => _PingState();
}

class _PingState extends State<Ping> {
  bool showSent = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("Friend Requests")),
      body: Column(
        children: [
          IconButton(
            onPressed:(){Navigator.of(context).push
            (MaterialPageRoute(builder: (context) => Search()));},
            icon: Icon(Icons.search),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => setState(() => showSent = true),
                child: Text("Sent Requests", style: TextStyle(fontWeight: showSent ? FontWeight.bold : FontWeight.normal)),
              ),
              TextButton(
                onPressed: () => setState(() => showSent = false),
                child: Text("Received Requests", style: TextStyle(fontWeight: !showSent ? FontWeight.bold : FontWeight.normal)),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Map<String,dynamic>>>(
              stream: showSent
                  ? provider.getSentRequests()
                  : provider.getReceivedRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No Friend Requests"));
                }
                final requests = snapshot.data!;
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final friendId = request['id'];
                    final friendName = request['name'];
                    return ListTile(
                      title: Text(friendName),
                      trailing: showSent
                          ? ElevatedButton(
                              child: Text("Cancel"),
                              onPressed: () {
                               provider.deleteFriendRequest(friendId);    
                              },
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  child: Text("Accept"),
                                  onPressed: () {
                                    provider.acceptFriendRequest(friendId);
                                  },
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  child: Text("Reject"),
                                  onPressed: () {
                                    provider.rejectFriendRequest(friendId);
                                  },
                                ),
                              ],
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
