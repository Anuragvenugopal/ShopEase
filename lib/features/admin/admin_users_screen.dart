import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/custom_app_bar.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Registered Users',
          showBackButton: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people_outline_rounded), text: 'Customers'),
              Tab(icon: Icon(Icons.admin_panel_settings_outlined), text: 'Administrators'),
            ],
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return Center(
                  child: Text(
                    'No registered users found.',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }

              
              final List<Map<String, dynamic>> admins = [];
              final List<Map<String, dynamic>> customers = [];

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final email = data['email'] as String? ?? '';
                if (email.toLowerCase() == 'admin@shopease.com') {
                  admins.add(data);
                } else {
                  customers.add(data);
                }
              }

              return TabBarView(
                children: [
                  _buildUserList(context, customers, 'No registered customers.', theme, isDark),
                  _buildUserList(context, admins, 'No administrators found.', theme, isDark),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(
    BuildContext context,
    List<Map<String, dynamic>> users,
    String emptyMessage,
    ThemeData theme,
    bool isDark,
  ) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final name = user['displayName'] ?? user['name'] ?? 'User';
        final email = user['email'] ?? 'No Email';
        final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161F30) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
              foregroundColor: theme.colorScheme.primary,
              child: Text(initial, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              email,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
