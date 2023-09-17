import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:flutter/services.dart';

final MethodChannel channel = MethodChannel('com.imin.printersdk');

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
              paxNotifier = int.tryParse(value) ?? 0;
            },
            controller: TextEditingController(text: paxNotifier.toString()),
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
                if (name == 'Adult') {
                  controller.paxAdultValue = paxNotifier;
                  controller.getQtyAdultNow();
                } else {
                  controller.paxChildValue = paxNotifier;
                  controller.getQtyChildNow();
                }

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
                  borderRadius: BorderRadius.circular(20.0),
                  color: controller.getSelectedVehicleTypeIndex() == index
                      ? Colors.green
                      : Colors.white,
                  border: Border.all(
                    color: controller.getSelectedVehicleTypeIndex() == index
                        ? Colors.white
                        : Colors.transparent,
                    width: 4.0,
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
                padding: const EdgeInsets.all(8.0),
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
                  borderRadius: BorderRadius.circular(20.0),
                  color: getColorFromText(item['color']),
                  border: Border.all(
                    color: controller.getSelectedVehicleColorIndex() == index
                        ? Colors.black
                        : Colors.transparent,
                    width: 4.0,
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

    Widget buildPaxCard(String title, String subtitle, int paxNotifier,
        incrementCallback, decrementCallback) {
      return Card(
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Container(
              width: 120,
              child: Row(children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    if (title == 'Adult') {
                      controller.paxAdultValue = paxNotifier + 10;
                      controller.getQtyAdultNow();
                    } else {
                      controller.paxChildValue = paxNotifier + 10;
                      controller.getQtyChildNow();
                    }
                  },
                  child: const Text("+10"),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    if (title == 'Adult') {
                      controller.paxAdultValue = paxNotifier + 20;
                      controller.getQtyAdultNow();
                    } else {
                      controller.paxChildValue = paxNotifier + 20;
                      controller.getQtyChildNow();
                    }
                  },
                  child: const Text("+20"),
                ),
                const SizedBox(
                  width: 5.0,
                ),
              ])),
          trailing: SizedBox(
            width: 120.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 17.0,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        decrementCallback();
                        print(paxNotifier);
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    dialogPax(paxNotifier, title, incrementCallback,
                        decrementCallback);
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          paxNotifier.toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 17.0,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        incrementCallback();
                        print(paxNotifier);
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15.0,
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
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Center(
          //     child: Badge(
          //       label: Text(
          //         "6",
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //       child: Icon(Icons.chat_bubble),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Center(
          //     child: Badge(
          //       label: Text(
          //         "3",
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //       child: Icon(Icons.notifications),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              QTextField(
                textCapitalization: true,
                label: "License Plate",
                value: "",
                onChanged: (value) {
                  licensePlate = value.toUpperCase();
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
              buildPaxCard("Adult", "", controller.getQtyAdultNow(),
                  controller.incrementPaxAdult, controller.decrementPaxAdult),

              // Generate a dynamic card for Child Pax
              buildPaxCard("Child", "", controller.getQtyChildNow(),
                  controller.incrementPaxChild, controller.decrementPaxChild),
              const SizedBox(
                height: 10.0,
              ),
              // clickBtn("init", () async {
              //   stateNotifier.value = await channel.invokeMethod("sdkInit");
              //   print(stateNotifier.value);
              // }),
              // clickBtn("getStatus", () async {
              //   stateNotifier.value =
              //       "getStatus : ${await channel.invokeMethod("getStatus")}";
              //   print(stateNotifier.value);
              // }),
              // clickBtn("printText", () async {
              //   stateNotifier.value = await channel.invokeMethod("printText", [
              //     "iMin committed to use advanced technologies to help our business partners digitize their business.We are dedicated in becoming a leading provider of smart business equipment " +
              //         "in ASEAN countries,assisting our partners to connect, create and utilize data effectively.\n"
              //   ]);
              // }),
              // clickBtn("printBitmap", () async {
              //   final ByteData bytes =
              //       await rootBundle.load('assets/icon/icon.png');
              //   //bytes.buffer.asUint8List();
              //   stateNotifier.value = await channel.invokeMethod(
              //       "printBitmap", {
              //     'image': bytes.buffer.asUint8List(),
              //     'type': 'image/png',
              //     'name': 'icon.png'
              //   });
              // }),
              // ValueListenableBuilder(
              // valueListenable: stateNotifier,
              // builder: (context, String value, child) {
              //   return Text(value);
              // }),

              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        child: QButton(
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
      ),
    );
  }

  Widget clickBtn(String title, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: MaterialButton(
        onPressed: onPressed,
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(title),
      ),
    );
  }

  @override
  State<DashboardView> createState() => DashboardController();
}
