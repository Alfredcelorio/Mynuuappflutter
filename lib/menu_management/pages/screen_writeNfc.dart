import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import 'dart:io';

import '../../common/services/providers.dart';
import '../../common/style/mynuu_colors.dart';

class ClassNfcPlugin extends StatefulWidget {
  @override
  _WriteExampleScreenState createState() => _WriteExampleScreenState();
}

class _WriteExampleScreenState extends State<ClassNfcPlugin>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  StreamSubscription<NDEFMessage>? _stream;
  bool _hasClosedWriteDialog = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _write(BuildContext context, String url) async {
    NDEFMessage message =
        NDEFMessage.withRecords([NDEFRecord.uri(Uri.parse(url))]);

    // Show dialog on Android (iOS has it's own one)
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: mynuuDarkGrey,
          title: const Text("Scan the tag you want to write to",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: 'Metropolis')),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(
                    color: mynuuRed, fontSize: 15, fontFamily: 'Metropolis'),
              ),
              onPressed: () {
                _hasClosedWriteDialog = true;
                _stream?.cancel();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    try {
      await NFC.writeNDEF(message, once: true).first;
      if (!_hasClosedWriteDialog) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success to "Ndef Write"')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error writing tag: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerR = context.watch<Providers>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Text("Hold your card close to your phone".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
          FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/icons/nfc2.jpg',
                height: 80.w,
                width: 80.w,
              )),
          SizedBox(
            width: 70.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(82, 46, 168, 1)),
              child: const Text("Begin activation"),
              onPressed: () => _write(context,
                  'https://mn.mynuutheapp.com/${providerR.r.shortUrl}'),
            ),
          ),
        ],
      ),
    );
  }
}



// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:nfc_manager/nfc_manager.dart';
// import 'package:project1/common/services/providers.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// import '../../common/services/nfc_plugin_provider.dart';

// class ClassNfcPlugin extends StatelessWidget {
//   const ClassNfcPlugin({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final nfcPlugin = context.watch<NfcPlugin>();
//     final providerR = context.watch<Providers>();
//     return SizedBox(
//         width: 100.w,
//         height: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               nfcPlugin.msg,
//               style: TextStyle(
//                   overflow: TextOverflow.clip,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'Metropolis',
//                   color: nfcPlugin.msg.contains('Success')
//                       ? Colors.green
//                       : Colors.white,
//                   fontSize: 16),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//                 width: 200,
//                 height: 40,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           const Color.fromRGBO(255, 255, 255, 0.05)),
//                   onPressed: () async {
//                     final result = await _ndefWrite(
//                         'https://mn.mynuutheapp.com/${providerR.r.shortUrl}');
//                     nfcPlugin.changeMsg(result);
//                   },
//                   child: const Text('Write to NFC'),
//                 )),
//           ],
//         ));
//   }

//   // void _tagRead() {
//   //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//   //     result.value = tag.data;
//   //     NfcManager.instance.stopSession();
//   //   });
//   // }

//   Future<String> _ndefWrite(String url) async {
//     var msg = '';
//     NfcManager.instance.startSession(
//         alertMessage: 'asdasd',
//         onDiscovered: (NfcTag tag) async {
//           var ndef = Ndef.from(tag);
//           if (ndef == null || !ndef.isWritable) {
//             msg = 'Error';
//             NfcManager.instance
//                 .stopSession(errorMessage: 'Tag is not ndef writable');
//             return;
//           }

//           NdefMessage message = NdefMessage([
//             NdefRecord.createMime(
//                 'text/plain', Uint8List.fromList(url.codeUnits)),
//           ]);

//           try {
//             await ndef.write(message);
//             msg = 'Success to "Ndef Write"';
//             NfcManager.instance.stopSession();
//           } catch (e) {
//             msg = e.toString();
//             NfcManager.instance.stopSession(errorMessage: e.toString());
//             return;
//           }
//         });
//     return msg;
//   }

//   // void _ndefWriteLock() {
//   //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//   //     var ndef = Ndef.from(tag);
//   //     if (ndef == null) {
//   //       result.value = 'Tag is not ndef';
//   //       NfcManager.instance.stopSession(errorMessage: result.value.toString());
//   //       return;
//   //     }

//   //     try {
//   //       await ndef.writeLock();
//   //       result.value = 'Success to "Ndef Write Lock"';
//   //       NfcManager.instance.stopSession();
//   //     } catch (e) {
//   //       result.value = e;
//   //       NfcManager.instance.stopSession(errorMessage: result.value.toString());
//   //       return;
//   //     }
//   //   });
//   // }
// }
