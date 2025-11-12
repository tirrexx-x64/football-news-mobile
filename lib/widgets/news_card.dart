import 'package:flutter/material.dart';
import 'package:football_news/screens/newslist_form.dart';
import 'package:football_news/screens/news_entry_list.dart';
import 'package:football_news/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// ======================================================
// Class ItemHomepage
// ======================================================
// Menyimpan data untuk setiap tombol card (name dan icon)
class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

// ======================================================
// Class ItemCard
// ======================================================
// Card tombol dengan ikon dan teks
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Add News") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup NewsFormPage.
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsFormPage(),
                ));
          } else if (item.name == "See Football News") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewsEntryListPage()
                ),
            );
          } else if (item.name == "Logout") {
            // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
            // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
            // If you using chrome,  use URL https://tirta-rendy-footballnews.pbp.cs.ui.ac.id

            final response = await request.logout(
                "https://tirta-rendy-footballnews.pbp.cs.ui.ac.id/auth/logout/");
            String message = response["message"];
            if (context.mounted) {
                if (response['status']) {
                    String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message See you again, $uname."),
                    ));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(message),
                      ),
                    );
                }
            }
          }

        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}