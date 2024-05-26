import 'package:flutter/material.dart';

extension SimplePadding on Widget {
  Widget bottomPadding(double padding) {
    if (padding == 0) {
      return this;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: this,
    );
  }

  Widget topPadding(double padding) {
    if (padding == 0) {
      return this;
    }
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: this,
    );
  }

  Widget rightPadding(double padding) {
    if (padding == 0) {
      return this;
    }
    return Padding(
      padding: EdgeInsets.only(right: padding),
      child: this,
    );
  }

  Widget leftPadding(double padding) {
    if (padding == 0) {
      return this;
    }
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: this,
    );
  }

  Widget horizontalPadding(double padding) {
    if (padding == 0) {
      return this;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
    );
  }

  Widget allPadding(EdgeInsets padding) {
    if (padding == EdgeInsets.zero) {
      return this;
    }
    return Padding(
      padding: padding,
      child: this,
    );
  }
}
