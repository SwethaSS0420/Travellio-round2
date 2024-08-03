import 'package:flutter/material.dart';
import 'package:travellio_round2/welcome.dart';

class ListItem {
  String title;
  String icon;
  String bgImage;
  bool isSelected;
  ListItem(this.title, this.icon, this.bgImage, {this.isSelected = false});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> items = [
    ListItem('Bulb', 'assets/bulb.png', 'assets/lightbg.png'),
    ListItem('TV', 'assets/tv.png', 'assets/tvbg.png'),
    ListItem('Lock', 'assets/lock.png', 'assets/lockbg.png'),
  ];
  String selectedBgImage='';
  int temp = 23;
  bool x=false;
  int get count => items.where((item) => item.isSelected).length;

  void toggleSelection(int index,bool x) {
    setState(() {
      x=!x;
      selectedBgImage = x?items[index].bgImage:'';
    });
  }
  void turnOn(int index) {
    setState(() {
      items[index].isSelected = !items[index].isSelected;
    });
  }

  void setTemp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Set Temperature', style: TextStyle(fontSize: 20)),
                  Slider(
                    value: temp.toDouble(),
                    min: 0,
                    max: 50,
                    divisions: 50,
                    label: temp.toString(),
                    onChanged: (double value) {
                      setModalState(() {
                        temp = value.toInt();
                      });
                      setState(() {});
                    },
                  ),
                  Text(
                    '${temp} °C',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void addItem() {
    setState(() {
      items.add(ListItem('AC', 'assets/ac.png', 'assets/acbg.png'));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF98A89D),
      appBar: AppBar(
        backgroundColor: Color(0xFF98A89D),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: selectedBgImage.isNotEmpty
              ? DecorationImage(
                  image: AssetImage(selectedBgImage),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Office',
                style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                count==1?'$count device active':'$count devices active',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setTemp(context),
                child: Container(
                  width: 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset('assets/thermometer.png'),
                      ),
                      Text('${temp} C'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 250),
              Container(
                height: 225,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: items.asMap().entries.map((entry) {
                    int index = entry.key;
                    ListItem item = entry.value;
                    return GestureDetector(
                      onTap: () => toggleSelection(index,x),
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        item.icon,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    item.title,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: GestureDetector(
                                onTap: () => turnOn(index),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: item.isSelected ? Colors.green : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {
                        addItem();
                      },
                    ),
                    const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
