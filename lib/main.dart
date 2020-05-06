import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main () => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async{

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados,"banco.db");

    var bd = await openDatabase( //abre e cria o banco de dados
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
        db.execute(sql);

      }
    );

   // print("aberto: " + bd.isOpen.toString());
    return bd;

  }

  _salvar() async {
    Database bd = await _recuperarBancoDados(); //acessa o banco criado

    Map<String, dynamic> dadosUsuario = {
      "nome" : "Zé Mané",
      "idade" : 46

    };
   int id = await bd.insert("usuarios", dadosUsuario); //sempre retonra o id
    print("Salvo: $id");

  }

  _listasUsuarios() async{
    Database bd = await _recuperarBancoDados(); //acessa o banco criado


    //clausulas sql -> https://www.w3schools.com/sql/
    //String sql = "SELECT * FROM usuarios WHERE nome = 'Fernando'"; //seleciona todas as colunas* da tabela usuarios WHERE XX=YYY Faz filtros
   // String sql = "SELECT * FROM usuarios WHERE idade >= 30 AND idade <= 46";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 30 AND 50";
   // String sql = "SELECT * FROM usuarios WHERE idade IN (10,30)";

   // String filtro = "z";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filtro + "%' ";
   // String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) DESC"; //ASC ou DESC - UPPER pra deixar tudo maicusculo
   // String sql = "SELECT *, UPPER(nome) as nome2 FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) DESC"; // UPPER pra deixar tudo maicusculo na execucao Ou LOWER
   // String sql = "SELECT *, UPPER(nome) as nome2 FROM usuarios WHERE 1=1 ORDER BY idade DESC, nome DESC LIMIT 3"; // Limita a quantidade de registros
    String sql = "SELECT * FROM usuarios"; // Limita a quantidade de registros
    List usuarios = await bd.rawQuery(sql); //retorna uma lista

    for (var usuario in usuarios ){
      print(
          "item id: " + usuario["id"].toString() +
          " nome: " + usuario["nome"] +
          " idade: " + usuario["idade"].toString()
      );
    }

    //print("usuarios: " + usuarios.toString());

  }

  _listarUsuarioPeloId (int id) async {
    Database bd = await _recuperarBancoDados(); //acessa o banco criado

    //CRUD - Create, Read, Update, Delete
    List usuarios = await bd.query(
        "usuarios",
      columns: ["id", "nome", "idade"],
      where: "id = ? AND nome LIKE ?",
      whereArgs: [id, "%Paula%"]
    );

    for (var usuario in usuarios ){
      print(
          "item id: " + usuario["id"].toString() +
              " nome: " + usuario["nome"] +
              " idade: " + usuario["idade"].toString()
      );
    }

  }

  _excluirUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete( //se executar sem clausula where apaga todo o bd
        "usuarios",
      where: "id = ? AND nome LIKE ?",
      whereArgs: [id, "%jose%"]
    );

    print("qnt removida: " + retorno.toString());

  }

  _atualizarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "David Kalil Braga"
    };

   int retorno = await bd.update( // se nao por clausula where vai atualizar o banco inteiro
        "usuarios",
        dadosUsuario,
        where: "id = ?",
        whereArgs: [id]
    );

    print("qnt alterada: " + retorno.toString());

  }


  @override
  Widget build(BuildContext context) {

   // _salvar();
    //_listasUsuarios();
    //_listarUsuarioPeloId(2);
    //_excluirUsuario(3);
    _atualizarUsuario(1);
    _listasUsuarios();


    return Container();
  }
}
