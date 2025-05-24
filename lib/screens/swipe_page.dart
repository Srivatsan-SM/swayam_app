import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SwipePage extends StatelessWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover People')),
      body: FutureBuilder(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data as List<Map<String, dynamic>>;
          return _buildSwipeCards(users);
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) throw Exception('Not logged in!');

    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .neq('id', currentUserId); // Don't fetch current user

    return response;
  }

  Widget _buildSwipeCards(List<Map<String, dynamic>> users) {
    // TODO: Implement swipe cards (next step)
    return Center(
      child: Text('${users.length} users found. Ready for swipe logic!'),
    );
  }
}