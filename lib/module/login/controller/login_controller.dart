import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/service/auth_service/auth_service.dart';
// import '../view/login_view.dart';

class LoginController extends State<LoginView> {
  static late LoginController instance;
  late LoginView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  do_login() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    showLoading();
    // var isSuccess =

    await AuthService().login(email: email!, password: password!);
    hideLoading();
    // if (!isSuccess) {
    //   await showDialog<void>(
    //     context: context,
    //     barrierDismissible: true,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Failed'),
    //         content: const SingleChildScrollView(
    //           child: ListBody(
    //             children: <Widget>[
    //               Text('Check your email or password'),
    //             ],
    //           ),
    //         ),
    //         actions: <Widget>[
    //           ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: Colors.blueGrey,
    //             ),
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: const Text("Ok"),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }
    Get.offAll(DashboardView());
  }
}
