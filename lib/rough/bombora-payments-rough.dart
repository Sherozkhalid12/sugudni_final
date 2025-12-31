import 'package:bambara_flutter/bambara_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';

class BomboraView extends StatelessWidget {
  const BomboraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: ()async{
          await BambaraView(
          data: BambaraData(
            amount: 1000,
            reference: "21e5ysuiadjaksd",
            phone: "778909878",
            email: "bass@gmail.com",
            name: "Bassirou",
            publicKey: "SDPiYtcuVr3b1bqaEo6ypnJAKTWfiA3RH4f7l3x8rTbU",),
          onClosed: () => print("CLOSED"),
          onError: (data) => print(data),
          onSuccess: (data) => print("SUCCESS HERE"),
          onProcessing: (data) => print("Processing HERE"),
          onRedirect: (data) => print("REDIRECT HERE"),
          closeOnComplete: false // Default value True. if True close the BambaraView widget automatically after calling onSuccess or onError
          ).show(context);
        }, child: MyText(text: "Open")),
      ),
    );
  }
}
