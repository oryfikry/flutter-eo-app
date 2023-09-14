
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import '../view/setting_view.dart';

class SettingController extends State<SettingView> {
    static late SettingController instance;
    late SettingView view;

    @override
    void initState() {
        instance = this;
        super.initState();
    }

    @override
    void dispose() => super.dispose();

    @override
    Widget build(BuildContext context) => widget.build(context, this);
}
        
    