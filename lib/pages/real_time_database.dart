import 'package:flutter/material.dart';

class RealTimeDatabase extends StatefulWidget {
  const RealTimeDatabase({Key? key}) : super(key: key);
  static const String id = 'real_time_database';

  @override
  _RealTimeDatabaseState createState() => _RealTimeDatabaseState();
}

class _RealTimeDatabaseState extends State<RealTimeDatabase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: (){},
                child: Text("Read examples"),
            ),
            MaterialButton(
              onPressed: (){},
              child: Text("Write examples"),
            )
          ],
        ),
      ),
    );
  }
}
