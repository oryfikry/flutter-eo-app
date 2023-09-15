import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:flutter/services.dart';

const MethodChannel channel = MethodChannel('com.imin.printersdk');

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

// printing
  ValueNotifier<String> stateNotifier = ValueNotifier("");
  ValueNotifier<String> libsNotifier = ValueNotifier("");
  ValueNotifier<String> scanNotifier = ValueNotifier("");

  Widget build(context, DashboardController controller) {
    ValueNotifier<int> paxAdultNotifier =
        ValueNotifier<int>(controller.paxAdultValue);
    ValueNotifier<int> paxChildNotifier =
        ValueNotifier<int>(controller.paxChildValue);

    Color getColorFromText(String colorText) {
      switch (colorText.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        default:
          return Colors.white;
      }
    }

    Future<void> dialogPax(
        paxNotifier, name, incrementCallback, decrementCallback) async {
      await showDialog(
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
        ),
      );
    }

    controller.view = this;

    var vehicle_type = Builder(
      builder: (context) {
        List items = [
          {"label": "Parkir Roda 2"},
          {"label": "Parkir Roda 4"},
          {"label": "Parkir Roda 6"},
          {"label": "Walking"},
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

            return GestureDetector(
              onTap: () {
                controller.setSelectedVehicleTypeIndex(index);
                controller.setVehicleType(item['label']);
                vehicleType = item['label'];
                print(item['label']);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: controller.getSelectedVehicleTypeIndex() == index
                      ? Colors.green
                      : Colors.white,
                  border: Border.all(
                    color: controller.getSelectedVehicleTypeIndex() == index
                        ? Colors.white
                        : Colors.transparent,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['label'],
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
          {"label": "White On Black", "color": "white"},
          {"label": "Black On Yellow", "color": "yellow"},
          {"label": "White On Red", "color": "red"},
          {"label": "Others", "color": "green"},
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
                controller.setSelectedVehicleColorIndex(index);
                controller.setVehicleColorCode(item['label']);
                vehicleColorCode = item['label'];
                print(item['label']);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: getColorFromText(item['color']),
                  border: Border.all(
                    color: controller.getSelectedVehicleColorIndex() == index
                        ? Colors.white
                        : Colors.transparent,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['label'],
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

    Widget buildPaxCard(String title, String subtitle,
        ValueNotifier<int> paxNotifier, incrementCallback, decrementCallback) {
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
                        decrementCallback();
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
                    dialogPax(paxNotifier, title, incrementCallback,
                        decrementCallback);
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
                        incrementCallback();
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
                child: Icon(Icons.chat_bubble),
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
              buildPaxCard("Adult", "", paxAdultNotifier,
                  controller.incrementPaxAdult, controller.decrementPaxAdult),

              // Generate a dynamic card for Child Pax
              buildPaxCard("Child", "", paxChildNotifier,
                  controller.incrementPaxChild, controller.decrementPaxChild),
              QButton(
                label: "init printer",
                onPressed: () {},
              ),
              const SizedBox(
                height: 10.0,
              ),
              QButton(
                label: "Save",
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      int paxChild = controller.paxChildValue;
                      int paxAdult = controller.paxAdultValue;
                      return AlertDialog(
                        title: const Text('Info'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  'licenseplate : $licensePlate \n Groupname : $groupName Vehicle Type : $vehicleType \n Vehicle Color Code : $vehicleColorCode \n Child : $paxChild \n Adult $paxAdult '),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<DashboardView> createState() => DashboardController();
}
