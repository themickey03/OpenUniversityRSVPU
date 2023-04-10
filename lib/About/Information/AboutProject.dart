import 'package:flutter/material.dart';


class AboutProjectWidget extends StatefulWidget {
  const AboutProjectWidget({super.key});

  @override
  _AboutProjectWidgetState createState() => _AboutProjectWidgetState();
}

class _AboutProjectWidgetState extends State<AboutProjectWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
        title: const Align(alignment: Alignment.centerLeft,child: Text("", style: TextStyle(fontSize: 24))),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("О ПРОЕКТЕ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text("Открытый университет РГППУ – это новый проект центра развития образовательных проектов Университета, "
                  "который представляет собой уникальную модель неформального образования для взрослых. "
                  "В рамках этого проекта, Университет предоставляет возможность получить качественное образование в различных областях знаний, "
                  "как традиционным, так и новым методами обучения.\n\n"
                  "Открытый университет РГППУ был создан с целью предоставления возможности для развития "
                  "профессиональных и личностных компетенций взрослым, которые не имеют возможности посещать традиционные "
                  "учебные заведения. Он предлагает широкий спектр курсов, позволяющих участникам выбрать "
                  "наиболее подходящую для себя программу обучения.\n\n"
                  "Открытый университет РГППУ - это идеальный выбор для взрослых, которые стремятся получить новые "
                  "знания и умения, улучшить свои профессиональные навыки или просто расширить кругозор.", textAlign: TextAlign.left,),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("НАША МИССИЯ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
              child: Text("Миссия «Открытого Университета» заключается в улучшении процессов обучения, "
                  "направленных на непрерывное повышение квалификации сотрудников и формирование современных компетенций, "
                  "которые необходимы для разработки и реализации конкурентоспособных, высокотехнологичных образовательных продуктов.\n\n"
                  "Целью «Открытого Университета» является создание условий для участия в профессиональном образовании людей, "
                  "независимо от их места жительства, возраста и образовательного уровня. Он предоставляет доступ к широкому спектру "
                  "образовательных программ, разработанных с учетом современных тенденций и потребностей рынка труда.\n\n"
                  "Основной задачей «Открытого Университета» является обеспечение качественного обучения, используя передовые методики и технологии. "
                  "Для достижения этой цели, Университет привлекает высококвалифицированных преподавателей и экспертов, которые имеют богатый опыт в "
                  "своей области и могут передавать свои знания и навыки участникам обучения.\n\n"
                  "Таким образом, «Открытый Университет» играет важную роль в совершенствовании системы профессионального образования "
                  "и повышении уровня квалификации сотрудников в различных областях. Он является идеальным выбором для тех, кто "
                  "стремится получить высококачественное образование и развить свои профессиональные навыки.", textAlign: TextAlign.left),
            )
          ],
        ),
      ),
    );
  }
}