import 'package:flutter/material.dart';
import '../view/dashboard_view.dart';

class DashboardController extends State<DashboardView> {
  static late DashboardController instance;
  late DashboardView view;
  int paxAdultValue = 0;
  int paxChildValue = 0;
  int selectedIndexVehicleType = 0;
  int selectedIndexVehicleColor = 0;
  String vehicleColor = "";
  String vehicleType = "";

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  void updateState(VoidCallback fn) {
    setState(fn);
  }

  void incrementPaxAdult() {
    setState(() {
      paxAdultValue += 1;
    });
  }

  void decrementPaxAdult() {
    if (paxAdultValue > 0) {
      setState(() {
        paxAdultValue -= 1;
      });
    }
  }

  void incrementPaxChild() {
    setState(() {
      paxChildValue += 1;
    });
  }

  void decrementPaxChild() {
    if (paxChildValue > 0) {
      setState(() {
        paxChildValue -= 1;
      });
    }
  }

  void setSelectedVehicleColorIndex(int index) {
    setState(() {
      selectedIndexVehicleColor = index;
    });
  }

  void setSelectedVehicleTypeIndex(int index) {
    setState(() {
      selectedIndexVehicleType = index;
    });
  }

  int getSelectedVehicleTypeIndex() {
    return selectedIndexVehicleType;
  }

  int getSelectedVehicleColorIndex() {
    return selectedIndexVehicleColor;
  }

  void setVehicleColorCode(String color) {
    setState(() {
      vehicleColor = color;
    });
  }

  void setVehicleType(String _vehicleType) {
    setState(() {
      vehicleType = _vehicleType;
    });
  }

  String getVehicleColorCode() {
    return vehicleColor;
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
