import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mobile_test/config/Routes.dart';
import 'package:mobile_test/controller/CharacterController.dart';
import 'package:mobile_test/models/Character.dart';
import 'package:mobile_test/models/Info.dart';
import 'package:mobile_test/models/allCharacters.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: routes(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mobile Teste'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _characters = [];
  int _page = 1;
  List<String> _types = ['name', 'status', 'species'];
  String _type = 'name';
  late Info _info;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  CharacterController _controller = CharacterController();
  TextEditingController _searchController = TextEditingController();
  late Future _futureCharacter;
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    if (_info.next != null) {
      setState(() {
        _futureCharacter = _controller.getAllCharacters(next: _info.next);
        _page++;
      });
    }

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void _filter() {
    setState(() {
      _futureCharacter = _controller.getFilterCharacters(
          type: _type, value: _searchController.text);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _futureCharacter = _controller.getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: Text(widget.title),
        ),
        body: _body()
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _body() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: _futureCharacter,
            builder: (context, AsyncSnapshot snapshot) {
              if (ConnectionState.waiting == snapshot.connectionState) {
                return Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.data == null) {
                return Column(
                  children: [
                    _header(),
                    Center(
                      child: Text('Nada encontrado'),
                    )
                  ],
                );
              }
              AllCharacters allCharacters = snapshot.data;
              _info = allCharacters.info;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text('Page ${_page} Arraste para baixo pra recarregar'),
                  ),
                  _listCharcters(characters: snapshot.data.results),
                ],
              );
            }));
  }

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Pesquisar',
                          contentPadding: EdgeInsets.only(left: 16.0),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          _filter();
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey.shade900,
                        ))
                  ],
                )),
          ),
          Expanded(
              child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.grey.shade400),
            child: DropdownSearch<String>(
                mode: Mode.MENU,
                items: _types,
                dropdownSearchDecoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 16.0)),
                onChanged: (selectedItem) {
                  setState(() {
                    _type = selectedItem!;
                  });
                },
                selectedItem: _type),
          ))
        ],
      ),
    );
  }

  Widget _listCharcters({required List<Character> characters}) {
    _characters = characters;
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, i) => _card(i),
          itemExtent: 100.0,
          itemCount: _characters.length,
        ),
      ),
    );
  }

  Widget _card(int index) {
    Character _character = _characters[index];
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
          child: Center(
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/character/detail',
                arguments: _character);
          },
          leading: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(_character.image)),
          title: Text(
            _character.name,
            style: TextStyle(color: Colors.grey.shade900),
          ),
          subtitle: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                      child: Text(_character.status),
                    )
                  ],
                ),
              ),
              // Text('Last Location know   - Earth')
            ],
          ),
        ),
      )),
    );
  }
}
