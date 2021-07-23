import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformViewsService.synchronizeToNativeViewHierarchy(false);

  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

enum PopupOption { option0, option1, option2 }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  BannerAd? _banner;
  bool _isAdLoaded = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.add(Text(
      'You have pushed the button this many times:',
    ));
    widgets.add(Text(
      '$_counter',
      style: Theme.of(context).textTheme.headline4,
    ));

    if (_isAdLoaded) {
      widgets.add(SizedBox(
          height: AdSize.banner.height.toDouble(),
          child: AdWidget(ad: _banner!)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<PopupOption>(
            itemBuilder: (BuildContext context) {
              return {
                PopupOption.option0,
                PopupOption.option1,
                PopupOption.option2,
              }.map((PopupOption option) {
                var text = '';
                switch (option) {
                  case PopupOption.option0:
                    text = 'Option 0';
                    break;
                  case PopupOption.option1:
                    text = 'Option 1';
                    break;
                  case PopupOption.option2:
                    text = 'Option 2';
                    break;
                }
                return PopupMenuItem<PopupOption>(
                    value: option, child: Text(text));
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  _createBannerAd() {
    if (_banner != null) return;

    _banner = BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (_) => setState(() {
                  _isAdLoaded = true;
                }),
            onAdFailedToLoad: (Ad ad, _) => ad.dispose()))
      ..load();
  }
}
