import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orbitnetmobileapp/screens/allScreens/activiteAtelier/activite_vehicule.dart';
import 'package:orbitnetmobileapp/screens/allScreens/chiffAffCredit/chiff_aff_credit.dart';
import 'package:orbitnetmobileapp/screens/allScreens/historiquVehicule/historique_vehicule.dart';
import 'package:orbitnetmobileapp/screens/allScreens/home/home.dart';
import 'package:orbitnetmobileapp/screens/allScreens/recette/recette.dart';
import 'package:orbitnetmobileapp/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  Future<Map<String, dynamic>?> getAccountInformation(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");

    if (user != null) {
      return jsonDecode(user);
    } else {
      return null;
    }
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()), 
      (Route<dynamic> route) => false,
    );
  }

 Future<Map<String, String>> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    if (user == null) {
      return {
        'HistVehic': "0",
        'CA': "0",
        'REC': "0",
        'ACT_AT': "0",
      };
    }
    Map<String, dynamic> json = jsonDecode(user);
    return {
      'HistVehic': json['HistVehic'] ?? "0",
      'CA': json['CA'] ?? "0",
      'REC': json['REC'] ?? "0",
      'ACT_AT': json['ACT_AT'] ?? "0",
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _loadPreferences(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading preferences'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No preferences found'));
        } else {
          final prefs = snapshot.data!;
          final histVehic = prefs['HistVehic']!;
          final ca = prefs['CA']!;
          final rec = prefs['REC']!;
          final actAt = prefs['ACT_AT']!;

          return Drawer(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: getAccountInformation(context), // Existing Future for account info
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> accountSnapshot) {
                if (accountSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (accountSnapshot.hasError) {
                  return const Center(child: Text('Error loading user information'));
                } else if (!accountSnapshot.hasData || accountSnapshot.data == null) {
                  return ListView(
                    children: [
                      const UserAccountsDrawerHeader(
                        accountName: Text('OrbitNet'),
                        accountEmail: Text('DealerName'),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image(
                              image: AssetImage("lib/assets/logo.png"),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Colors.yellow[800],
                        ),
                        title: const Text('Home Page'),
                        onTap: () async {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                histVehic: histVehic,
                                ca: ca,
                                rec: rec,
                                actAt: actAt,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                      if (ca != "0")
                        ListTile(
                          leading: Icon(
                            Icons.monetization_on_sharp,
                            color: Colors.yellow[800],
                          ),
                          title: const Text('Chiffre Affaire Credit'),
                          onTap: () => selectedItem(context, 0),
                        ),
                      if (rec != "0")
                        ListTile(
                          leading: Icon(
                            Icons.point_of_sale,
                            color: Colors.yellow[800],
                          ),
                          title: const Text('Recette'),
                          onTap: () => selectedItem(context, 1),
                        ),
                      if (histVehic != "0")
                        ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Colors.yellow[800],
                          ),
                          title: const Text('Historique vehicule'),
                          onTap: () => selectedItem(context, 2),
                        ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text('Logout'),
                        onTap: () => logout(context),
                      ),
                    ],
                  );
                } else {
                  final userInfo = accountSnapshot.data!;
                  return ListView(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(userInfo["UserName"] ?? 'OrbitNet'),
                        accountEmail: Text(userInfo["DealerName"] ?? 'DealerName'),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              "lib/assets/logo.png",
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.indigo,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Colors.yellow[800],
                        ),
                        title: const Text('Home Page'),
                        onTap: () => selectedItem(context, 3),
                      ),
                      if (ca != "0")
                        ListTile(
                          leading: Icon(
                            Icons.monetization_on_sharp,
                            color: Colors.yellow[800],
                          ),
                          title: const Text('Chiffre Affaire Credit'),
                          onTap: () => selectedItem(context, 0),
                        ),
                      if (rec != "0")
                        ListTile(
                          leading: Icon(
                            Icons.point_of_sale,
                            color: Colors.yellow[800],
                          ),
                          title: const Text('Recette'),
                          onTap: () => selectedItem(context, 1),
                        ),
                      if (histVehic != "0")
                        ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Colors.yellow[800],
                          ),
                          title: const Text('Historique Vehicule'),
                          onTap: () => selectedItem(context, 2),
                        ),
                      if (actAt != "0")
                        ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Colors.yellow[800],
                          ),
                          title: const Text('Activité Atelier'),
                          onTap: () => selectedItem(context, 3),
                        ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text('Logout'),
                        onTap: () => logout(context),
                      ),
                    ],
                  );
                }
              },
            ),
          );
        }
      },
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ChiffAffCreditRech(key: GlobalKey<FormState>())),
            (Route<dynamic> route) => false,
          );
          break;
        }
      case 1:
        {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RecetteRech(key: GlobalKey<FormState>())),
            (Route<dynamic> route) => false,
          );
          break;
        }
      case 2:
        {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HistoriqueVehicule(key: GlobalKey<FormState>())),
            (Route<dynamic> route) => false,
          );
          break;
        }
      case 3:
        {
          SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? user = prefs.getString("user");
                    Map<String, dynamic> json = jsonDecode(user!);
                    String histVehic = json['HistVehic'];
                    String ca ="-1";
                    String rec ="-1";
                    String actAt ="-1";
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => 
              HomePage(histVehic:histVehic, ca: ca, rec: rec, actAt: actAt)),
            (Route<dynamic> route) => false,
          );
          break;
        }
      case 4:
      {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>ActiviteVehicule()),
          (Route<dynamic> route) => false,
        );
        break;
      }
    }
  }
}
