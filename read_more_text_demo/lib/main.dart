import 'package:flutter/material.dart';
import 'fake_data.dart';
import 'read_more_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'read_more_text Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'read_more_text Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> _textList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textList = faketext;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _textList.length,
          itemBuilder: (context, index){
            return TextCell(_textList[index]);
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TextCell extends StatelessWidget {
  final String text;
  const TextCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFF7953),
          ),
          padding: EdgeInsets.all(5.0),
          child: ReadMoreText(
            text,
            maxLines: 3,
//            colorClickableText: Colors.blue,
            unfoldTail: ReadMoreTail(
              text: Text(
                  ' ... 查看更多',
              ),
              tailAlign: ReadMoreTailAlign.ReadMoreTailAlignEnd,

            ),
            foldTail: ReadMoreTail(
              text: Text(
                  ' 收起内容',
              ),
              tailAlign: ReadMoreTailAlign.ReadMoreTailAlignNextLineEnd,
            ),

          ),
        ),
      ),
    );
  }
}