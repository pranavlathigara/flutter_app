import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_index.dart';
import 'register_page.dart';
import 'reset_password_page.dart';

class QuicklyLoginPage extends StatefulWidget {
  QuicklyLoginPage({Key key}) : super(key: key);

  @override
  createState() => _QuicklyLoginPageState();
}

class _QuicklyLoginPageState extends State<QuicklyLoginPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _vCodeController = TextEditingController();

  final FocusNode _nodePhone = FocusNode();
  final FocusNode _nodeVCode = FocusNode();

  bool _isClick = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_verify);
    _vCodeController.addListener(_verify);

    initSpDate();
  }

  void _verify() {
    String name = _phoneController.text;
    String vCode = _vCodeController.text;
    if (name.isEmpty || name.length < 11) {
      setState(() => _isClick = false);
      return;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      setState(() => _isClick = false);
      return;
    }

    setState(() => _isClick = true);
  }

  @override
  void dispose() {
    _phoneController?.dispose();
    _vCodeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            leading: CloseButton(),
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${AppLocalizations.$t('quickly_login')}",
                      style: TextStyles.textBoldDark26),
                  Gaps.vGap16,
                  CustomTextField(
                      focusNode: _nodePhone,
                      nextFocusNode: _nodeVCode,
                      controller: _phoneController,
                      maxLength: 11,
                      keyboardType: TextInputType.phone,
                      hintText: "${AppLocalizations.$t('input_phone')}"),
                  Gaps.vGap10,
                  CustomTextField(
                      focusNode: _nodeVCode,
                      controller: _vCodeController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      hintText: "${AppLocalizations.$t('input_v_code')}",
                      getVCode: () {
                        Toast.show(
                            '${AppLocalizations.$t('get_v_code')}', context);
                      }),
                  Gaps.vGap10,
                  Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          child: RichText(
                              text: TextSpan(
                                  text: '${AppLocalizations.$t('tip')}',
                                  style: TextStyles.textGray14,
                                  children: <TextSpan>[
                                TextSpan(
                                    text: '${AppLocalizations.$t('register')}',
                                    style: TextStyle(color: Colors.redAccent)),
                                TextSpan(text: '。')
                              ])),
                          onTap: () => pushNewPage(context, RegisterPage()))),
                  Gaps.vGap25,
                  Button(
                      borderRadius: 0,
                      onPressed: _isClick ? _login : null,
                      text: "${AppLocalizations.$t('login')}"),
                  Gaps.vGap10,
                  Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          child: Padding(
                              child: Text(
                                  '${AppLocalizations.$t('forgot_password')}',
                                  style: TextStyles.textGray14),
                              padding: EdgeInsets.all(10)),
                          onTap: () =>
                              pushNewPage(context, ResetPasswordPage())))
                ])));
  }

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login_phone', _phoneController.text);

    Navigator.pop(context);
  }

  void initSpDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _phoneController.text = prefs.getString('login_phone'));
  }
}
