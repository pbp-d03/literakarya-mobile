import 'package:flutter/material.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/user_profile/models/user.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AllAccountPage extends StatefulWidget {
  const AllAccountPage({Key? key});

  @override
  State<StatefulWidget> createState() => _AllAccountPageState();
}

class _AllAccountPageState extends State<AllAccountPage> {
  List<User> allAccount = [];

  Future<void> fetchAccount(request) async {
    try {
      var data = await request.get('https://literakarya-d03-tk.pbp.cs.ui.ac.id/user_profile/get-allaccount/');
      List<User> listAccount = [];
      for (var d in data) {
        if (d != null) {
          User account = User.fromJson(d);
          if (account.fields.username != "adminliterakarya") {
            listAccount.add(account);
          }
        }
      }
      setState(() {
        allAccount = listAccount;
      });
    } catch (e) {
      print('Error fetching account: $e');
    }
  }

  Future<void> deleteAccount(int accountId, CookieRequest request) async {
    try {
      final Uri url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/user_profile/delete-account-flutter/$accountId/');
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        print('Account deleted successfully');
        setState(() {
          allAccount.removeWhere((account) => account.pk == accountId);
        });
      } else {
        print('Failed to delete account, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting account: $e');
    }
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAccount(Provider.of<CookieRequest>(context, listen: false));
    });
  }

  void refreshAccountList() {
    fetchAccount(Provider.of<CookieRequest>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar akun',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,

      ),
      drawer: buildDrawer(context),
      
      body: Column(
        children: [
          // Note list or no note text
          Expanded(
            child: allAccount.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada akun.",
                    style: TextStyle(color: Color.fromARGB(255, 38, 166, 154), fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: allAccount.length,
                  itemBuilder: (_, index) {
                    return Card(
                      color: Colors.teal.shade50,
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(allAccount[index].fields.username),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            int accountId = allAccount[index].pk;
                            await deleteAccount(accountId, request);
                          },
                        ),
                      ),
                    );
                  },
                ),
            ),
      ]),
    );
  }
}
