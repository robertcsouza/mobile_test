import 'package:flutter/material.dart';
import 'package:mobile_test/models/Character.dart';

class CharacterDetail extends StatefulWidget {
  const CharacterDetail({Key? key}) : super(key: key);

  @override
  State<CharacterDetail> createState() => _CharacterDetailState();
}

class _CharacterDetailState extends State<CharacterDetail> {
  @override
  Widget build(BuildContext context) {
    final _character = ModalRoute.of(context)!.settings.arguments as Character;

    return Scaffold(
      body: _body(_character),
    );
  }

  Widget _body(Character _character) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.450,
              child: Image.network(
                _character.image,
                fit: BoxFit.fill,
              )),
          Positioned(
            bottom: 0,
            child: Material(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.60,
                child: _details(_character),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0),
            child: _appBarCustom(),
          ),
        ],
      ),
    );
  }

  Widget _details(Character _character) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _character.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: _character.status != 'Alive'
                            ? Colors.red
                            : Colors.green,
                        size: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _character.status,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 16.0),
              child: Text(
                'Last know Location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64.0, top: 8.0),
              child: Text(_character.location.name),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 16.0),
              child: Text(
                'First seen in',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64.0, top: 8.0),
              child: Text(_character.episode.first),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 16.0),
              child: Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64.0, top: 8.0),
              child: Text(_character.gender),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 16.0),
              child: Text(
                'Origin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64.0, top: 8.0),
              child: Text(_character.origin.name),
            )
          ],
        ));
  }

  Widget _appBarCustom() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              width: 40,
              height: 40,
              child: ClipOval(
                child: Material(
                  color: Colors.white, // Button color
                  child: InkWell(
                    splashColor: Colors.grey.shade900, // Splash color
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.grey.shade900,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
