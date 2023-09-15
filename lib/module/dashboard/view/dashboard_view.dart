import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class DashboardView extends StatefulWidget {
  DashboardView({Key? key}) : super(key: key);

  static String? licensePlate;
  static String? vehicleType;
  static String? vehicleColorCode;
  static String? groupName;
  static int? paxChild = 0;
  static int? paxAdult = 0;
  static String? personInCharge;
  static String? remarks;

  Widget build(context, DashboardController controller) {
    ValueNotifier<int> paxAdultNotifier = ValueNotifier<int>(0);
    ValueNotifier<int> paxChildNotifier = ValueNotifier<int>(0);

    Color getColorFromText(String colorText) {
      switch (colorText.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        // Add more cases for other colors as needed
        default:
          return Colors
              .white; // Default color if the text doesn't match any known color
      }
    }

    Future dialogPax(paxNotifier, name) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('$name Pax Qty'),
              content: TextField(
                onChanged: (value) {
                  paxNotifier.value = int.tryParse(value) ?? 0;
                },
                controller:
                    TextEditingController(text: paxNotifier.value.toString()),
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: '0'),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    print(name);
                    print(paxNotifier.value);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Submit"),
                ),
              ],
            ));

    controller.view = this;
    var vehicle_type = Builder(
      builder: (context) {
        List items = [
          {"lable": "Parkir Roda 2"},
          {"lable": "Parkir Roda 4"},
          {"lable": "Parkir Roda 6"},
          {"lable": "Walking"},
        ];
        int selectedIndex = 0;
        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0,
            crossAxisCount: 4,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: items.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var item = items[index];
            return InkWell(
              onTap: () {
                vehicleType = item['lable'];
                print(vehicleType);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 3, // Blur radius
                      offset: Offset(0, 3), // Offset
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['lable'],
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    var vehicle_color_code = Builder(
      builder: (context) {
        List items = [
          {"lable": "White On Black", "color": "white"},
          {"lable": "Black On Yellow", "color": "yellow"},
          {"lable": "White On Red", "color": "red"},
          {"lable": "Others", "color": "green"},
        ];
        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0,
            crossAxisCount: 4,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: items.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var item = items[index];
            return InkWell(
              onTap: () {
                vehicleColorCode = item['lable'];
                print(vehicleColorCode);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: getColorFromText(item['color']),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 3, // Blur radius
                      offset: Offset(0, 3), // Offset
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['lable'],
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    Widget buildPaxCard(
        String title, String subtitle, ValueNotifier<int> paxNotifier) {
      return Card(
        child: ListTile(
          title: Text(title),
          trailing: SizedBox(
            width: 120.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 12.0,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        if (paxNotifier.value > 0) {
                          paxNotifier.value -= 1;
                        }
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 9.0,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    dialogPax(paxNotifier, title);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: ValueListenableBuilder<int>(
                      valueListenable: paxNotifier,
                      builder: (context, value, child) {
                        return Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 12.0,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        paxNotifier.value += 1;
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 9.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Badge(
                label: Text(
                  "6",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Icon(MdiIcons.chatQuestion),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Badge(
                label: Text(
                  "3",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Icon(Icons.notifications),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              QTextField(
                label: "License Plate",
                validator: Validator.required,
                value: "",
                onChanged: (value) {
                  licensePlate = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              QDropdownField(
                label: "Group Name",
                validator: Validator.required,
                items: [
                  {
                    "label": "Group 1",
                    "value": 1,
                  },
                  {
                    "label": "Group 2",
                    "value": 2,
                  },
                  {
                    "label": "Group 3",
                    "value": 3,
                  },
                  {
                    "label": "Group 4",
                    "value": 4,
                  },
                ],
                onChanged: (value, label) {
                  groupName = label;
                  print(label);
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Vehicle Type",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              vehicle_type,
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Vehicle Color Code",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              vehicle_color_code,
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Pax",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              buildPaxCard("Adult", "", paxAdultNotifier),

              // Generate a dynamic card for Child Pax
              buildPaxCard("Child", "", paxChildNotifier),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<DashboardView> createState() => DashboardController();
}
