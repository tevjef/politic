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
  bool isLoading;
  ButtonGroup(this.primaryCtaText, this.primaryListener, {this.secondaryCtaText, this.secodaryListener, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget;
    if (isLoading) {
      buttonWidget = SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
          ));
    } else {
      buttonWidget = Text(primaryCtaText.toUpperCase());
    }
    var primaryButton = SizedBox(
        width: double.infinity,
        child: RaisedButton(
          elevation: 0,
          textTheme: ButtonTextTheme.primary,
          onPressed: isLoading ? null : primaryListener,
          child: Column(
            children: <Widget>[
              buttonWidget,
            ],
          ),
        ));

    Widget secondaryCta = Container();
    if (secondaryCtaText != null) {
      secondaryCta = SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: MaterialButton(
            onPressed: isLoading ? null : secodaryListener,
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

  const Headline(this.title, this.message, {Key key}) : super(key: key);

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

class ListCell extends StatelessWidget {
  final String title;
  final String message;

  const ListCell(this.title, this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Styles.headline6(Theme.of(context)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              message,
              style: Styles.body2(Theme.of(context)),
            ),
          ),
        ],
      ),
    );
  }
}

class ListButtonCell extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final Function callback;

  const ListButtonCell(this.title, this.message, this.buttonText, this.callback, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 32.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Styles.headline6(Theme.of(context)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    message,
                    style: Styles.body2(Theme.of(context)),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            elevation: 0,
            textTheme: ButtonTextTheme.primary,
            onPressed: callback,
            child: Text(buttonText.toUpperCase()),
          )
        ],
      ),
    );
  }
}

class ImageHeadline extends StatelessWidget {
  final String title;
  final AssetImage assetImage;

  const ImageHeadline(this.title, this.assetImage, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Image(image: assetImage),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Styles.headline5(Theme.of(context)),
          ),
        ],
      ),
    );
  }
}
