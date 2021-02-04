
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
        path: 'assets/translations', // <-- change patch to your
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()
    ),
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('整個重build');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Scaffold(body: SafeArea(child: FirstPage())),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  int currentLan = 0;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center ,
        children: [
          Text('title'.tr()),

          RaisedButton(
              child:  Text('hello'.tr()),
              onPressed: (){
                if(currentLan == 0){
                  EasyLocalization.of(context).locale = Locale('th', 'TH');
                  currentLan = 1;
                }else{
                  EasyLocalization.of(context).locale =  Locale('en', 'US');
                  currentLan = 0;
                }
              })
        ],
      ),
    );
  }
}
