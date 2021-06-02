import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Mail {
  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static Future openEmail({
    @required String? toEmail,
    @required String? subject,
    @required String? body,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject.toString())}&body=${Uri.encodeFull(body.toString())}';

    await _launchUrl(url);
  }
}
