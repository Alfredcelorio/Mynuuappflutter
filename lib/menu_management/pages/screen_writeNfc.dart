import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:project1/common/services/providers.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../common/services/nfc_plugin_provider.dart';

class ClassNfcPlugin extends StatelessWidget {
  const ClassNfcPlugin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nfcPlugin = context.watch<NfcPlugin>();
    final providerR = context.watch<Providers>();
    return SizedBox(
        width: 100.w,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nfcPlugin.msg,
              style: TextStyle(
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Metropolis',
                  color: nfcPlugin.msg.contains('Success')
                      ? Colors.green
                      : Colors.white,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(255, 255, 255, 0.05)),
                  onPressed: () async {
                    final result = await _ndefWrite(
                        'https://mn.mynuutheapp.com/${providerR.r.shortUrl}');
                    nfcPlugin.changeMsg(result);
                  },
                  child: const Text('Write to NFC'),
                )),
          ],
        ));
  }

  // void _tagRead() {
  //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //     result.value = tag.data;
  //     NfcManager.instance.stopSession();
  //   });
  // }

  Future<String> _ndefWrite(String url) async {
    var msg = '';
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        NfcManager.instance
            .stopSession(errorMessage: 'Tag is not ndef writable');
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createMime('text/plain', Uint8List.fromList(url.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        msg = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        msg = e.toString();
        NfcManager.instance.stopSession(errorMessage: e.toString());
        return;
      }
    });
    return msg;
  }

  // void _ndefWriteLock() {
  //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //     var ndef = Ndef.from(tag);
  //     if (ndef == null) {
  //       result.value = 'Tag is not ndef';
  //       NfcManager.instance.stopSession(errorMessage: result.value.toString());
  //       return;
  //     }

  //     try {
  //       await ndef.writeLock();
  //       result.value = 'Success to "Ndef Write Lock"';
  //       NfcManager.instance.stopSession();
  //     } catch (e) {
  //       result.value = e;
  //       NfcManager.instance.stopSession(errorMessage: result.value.toString());
  //       return;
  //     }
  //   });
  // }
}
