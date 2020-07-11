import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/animation/animation.dart';
import 'package:politic/ui/util/lib.dart';

import 'rv.dart';

class TextItem extends Item {
  String text;
  TextItem(this.text) : super(text);

  @override
  Widget create(BuildContext context, int position, int adapterPosition, [Animation<double> animation]) {
    return Row(children: <Widget>[Flexible(child: Text(text))]);
  }
}

class ButtonGroup extends StatelessWidget {
  String primaryCtaText;
  Function primaryListener;
  String secondaryCtaText;
  Function secodaryListener;

  ButtonGroup(this.primaryCtaText, this.primaryListener, {this.secondaryCtaText, this.secodaryListener});

  @override
  Widget build(BuildContext context) {
    var primaryButton = SizedBox(
        width: double.infinity,
        child: RaisedButton(
          elevation: 0,
          textTheme: ButtonTextTheme.primary,
          onPressed: primaryListener,
          child: Text(primaryCtaText.toUpperCase()),
        ));

    Widget secondaryCta = Container();
    if (secondaryCtaText != null) {
      secondaryCta = SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: MaterialButton(
            onPressed: secodaryListener,
            child: Text(secondaryCtaText.toUpperCase()),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[primaryButton, secondaryCta],
        ),
      ),
    );
  }
}

class Headline extends StatelessWidget {
  final String title;
  final String message;

  const Headline({Key key, this.title = "", this.message = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageWidget = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        message,
        style: Styles.subtitle2(Theme.of(context)),
      ),
    );

    if (message == "") {
      messageWidget = new Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Styles.headline5(Theme.of(context)),
          ),
          messageWidget,
        ],
      ),
    );
  }
}
