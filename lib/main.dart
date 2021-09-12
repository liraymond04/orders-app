import 'package:flutter/material.dart';
import 'package:orders_app/models/cart.dart';
import 'package:orders_app/widgets/tabs/tabs_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:introduction_screen/introduction_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()),
      ],
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders',
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Splash();
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({ Key? key }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash>{
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = prefs.getBool('seen') ?? false;

    if (_seen) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Root(),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => IntroPage(),
      ));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return TabsPage(firestore: _firestore, storage: _storage);
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({ Key? key }) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future setToSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
  }

  void _onIntroEnd(context) {
    setToSeen();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Root()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16, right: 16),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "We just need some details before you can continue",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Name",
          body: "What is your name? We need to know so we can deliver to you.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Email",
          body: "Please enter your email for order confirmations.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "School",
          body: "Let us know which school we can find you at.",
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text('Skip'),
      next: Icon(Icons.arrow_forward),
      prev: Icon(Icons.arrow_back),
      done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: EdgeInsets.all(16),
      controlsPadding: EdgeInsets.all(12.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}