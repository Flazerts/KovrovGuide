// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget buildPlatformWidget(String url) {
  final viewId = 'iframe-${url.hashCode}';
  
  // Регистрируем iframe для встраивания сайта внутрь приложения
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int id) => html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%',
  );

  return HtmlElementView(viewType: viewId);
}