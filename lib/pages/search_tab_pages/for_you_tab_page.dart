import 'package:flutter/material.dart';

class ForYouTabPage extends StatefulWidget {
  const ForYouTabPage({super.key});

  @override
  State<ForYouTabPage> createState() => _ForYouTabStatePage();
}

class _ForYouTabStatePage extends State<ForYouTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.3,
              decoration: const BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(
                    "https://img.olympics.com/images/image/private/t_16-9_760/f_auto/primary/hyx0yrwwlx4ps0icteji",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trending in India",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "#ViratKholi",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "40.5k posts",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert_rounded),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sports  Trending",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "FOOTBALL",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "186.51k posts",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
