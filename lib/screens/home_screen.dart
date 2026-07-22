import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Hello, Flutter'),
            SizedBox(height: 20,),
            Icon(Icons.calendar_month_sharp, size: 67, color: Colors.amber,),
            Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEwLEJBrGEdRluMAEml_3A5PHjRYvn9KhWjD6VsZ1l1UJhKIv8mLAEFuMm&s=10'),
            Stack(
              children:[              
                CircleAvatar(
                  radius: 67,
                  backgroundImage: NetworkImage('https://png.pngtree.com/png-vector/20251222/ourmid/pngtree-gyudon-japanese-beef-bowl-illustration-in-cartoon-style-vector-png-image_18288110.webp'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.amber,
                        ),
                      ),
                ),
              ],
            ),
          ],
        )       
      ),
    );
  }
}
