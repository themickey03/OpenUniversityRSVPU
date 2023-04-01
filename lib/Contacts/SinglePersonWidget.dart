
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/Contacts/SinglePersonModel.dart';

class SinglePersonWidget extends StatelessWidget {
  final SinglePersonModel singlePersonModel;

  const SinglePersonWidget({Key? key, required this.singlePersonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(singlePersonModel.name),),
      body: ListView(
        children: [
          Container(
            height: 400,
            width: 150,
            margin: EdgeInsets.only(bottom: 5.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
              color: Colors.blueAccent,
            ),
            child: SizedBox(
              width: 100,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(opacity: 0.3,
                  child: Image.network(singlePersonModel.img_link, color: Colors.black)),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder:
                        'images/Loading_icon.gif',
                        image: singlePersonModel.img_link != "" ? singlePersonModel.img_link : "http://koralex.fun:3000/_nuxt/assets/images/logo.png",
                        fit: BoxFit.contain,
                        width: double.maxFinite,
                        height: double.maxFinite,
                      ),
                    ),
                  ),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.center,child: Text(singlePersonModel.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                singlePersonModel.job_title != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Должность: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.job_title)
                    ])) : Container(),
                singlePersonModel.structure != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Структурное подразделение: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.structure)
                    ])) : Container(),
                singlePersonModel.academic_degree != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Ученая степень: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.academic_degree)
                    ])) : Container(),
                singlePersonModel.academic_title != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Ученое звание: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.academic_title)
                    ])) : Container(),
                singlePersonModel.desc != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Краткие биографические данные: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.desc)
                    ])) : Container(),
                singlePersonModel.scientific_interests != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Область научных интересов: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.scientific_interests)
                    ])) : Container(),
                singlePersonModel.prizes != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Награды: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.prizes)
                    ])) : Container(),
                singlePersonModel.publishing != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Значимые публикации: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.publishing)
                    ])) : Container(),
                singlePersonModel.phone != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "Телефон для связи: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.phone)
                    ])) : Container(),
                singlePersonModel.email != "" ? SelectableText.rich(TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: "EMail для связи: ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      TextSpan(text: singlePersonModel.email)
                    ])) : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}