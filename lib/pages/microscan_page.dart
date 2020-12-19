import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/barcaode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:secrets/secrets.dart';
import 'package:encrypt/encrypt.dart';

///
/// FullScreenScannerPage
class FullScreenScannerPage extends StatefulWidget {
  final String userId;
  FullScreenScannerPage(this.userId);
  @override
  _FullScreenScannerPageState createState() => _FullScreenScannerPageState();
}

class _FullScreenScannerPageState extends State<FullScreenScannerPage> {
  final publicKey = Secrets.microPubKey;

  Future<String> decrypt(String encryptedText) async {
    try {
      final pubK = RSAKeyParser().parse("-----BEGIN PUBLIC KEY-----\r" + publicKey + "\r-----END PUBLIC KEY-----");
      final encrypter = Encrypter(RSAReversed(
        publicKey: pubK,
      ));
      final encrypted = Encrypted.fromBase64(encryptedText);
      final decrypted = encrypter.decrypt(encrypted);

      return decrypted;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppBarcodeScannerWidget.defaultStyle(
        resultCallback: (String code) {
          print(code);
          decrypt(code).then((value) {
            if (value == null) {
              navigator.pop();
              AdaptiveComponents.showToast(context, "无法使用的二维码");
            } else {
              var codev = value.split('+');
              var tt = codev[0];
              var url = codev[1];
              var token = codev[2];
              navigator.pop();
              AdaptiveComponents.showAlertDialog(
                context,
                title: tt,
                onDismiss: (value1) {
                  if (value1 == AlertResult.confirm) {
                    var body = {
                      'token': token,
                      'bbs_id': widget.userId,
                    };
                    Request.httpPost(url, body).then((response) {
                      // var resultMap = jsonDecode(
                      //   ascii.decode(response.bodyBytes),
                      // );
                    }).catchError((e) {
                      AdaptiveComponents.showToast(context, "出错请重试");
                    });
                  }
                },
              );
            }
          });
        },
      ),
    );
  }
}
