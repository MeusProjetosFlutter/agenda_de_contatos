import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//dados que serao usados na criacao da tabela do banco de dados
final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database? _db; //declarando o banco de dados

  get db async {
    if (_db != null) {
      //se já foi criado retorne o banco de dados
      return _db;
    } else {
      //caso nao foi criado,  inicializar o banco de dados
      _db = await initDb();
    }
  }

  //funcao apra inicializar o banco de dados
  Future<Database> initDb() async {
    final String databasesPath =
        await getDatabasesPath(); //pegar o diretorio do banco de dados no dispositivo
    final path = join(
      await getDatabasesPath(),
      "contacts.db",
    ); //juntar o nome do arquivo do banco de dados ao diretorio do banco de dados

    //abrindo o banco de dados
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerversion) async {
        await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT, $telefoneColumn TEXT, $imgColumn TEXT",
        );
      },
    );
  }

  //_____________________Salvando o contato no banco_________________________________
  Future<dynamic> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(
      contactTable,
      contact.toMap(),
    ); //passando o ID dado pelo banco para a atributo "id" do novo contato
    return contact;
  }

  //____________________retornar os dados de um contato________________________________
  Future<Contact?> getContact(int id) async {
    Database dbContact = await db;
    List<Map<String, dynamic>> map = await dbContact.query(
      contactTable,
      //se nao especificarmos as colunas, ele retornara todas colunas
      columns: [idColumn, nomeColumn, emailColumn, telefoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    return map.isNotEmpty ? Contact.fromMap(map.first) : null;
  }

  //_________________retornando todos os dados do banco_________________________________

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;
    //se nao passar o o valor no parametro "where" ele retorna todos os dados
    List<Map<String, dynamic>> allContacts = await dbContact.rawQuery(
      "SELECT * FROM $contactTable",
    );
    List<Contact> contactList = [];
    for (Map<String, dynamic> contactMap in allContacts) {
      contactList.add(Contact.fromMap(contactMap));
    }
    return contactList;
  }

  //__________________deletando contato do banco______________________________________
  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(
      contactTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  //__________________deletando todos os contatos do banco____________________________
  Future<int> deleteAllContacts() async {
    Database dbContact = await db;
    return await dbContact.delete(contactTable);
  }

  //__________________atualizando contato do banco___________________________________

  updateContact(Contact contact) async {
    Database dbContact = await db;
    dbContact.update(
      contactTable,
      contact.toMap(),
      where: "$idColumn = ?",
      whereArgs: [contact.id],
    );
  }

  //__________________pegando numero de contatos do banco___________________________________

  Future<int?> getNumber() async {
    Database dbContact = await db;
    return await Sqflite.firstIntValue(
      await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"),
    );
  }

  //__________________fechando o banco de dados______________________________________________

  Future<void> closeDB() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

//dados do usuario
class Contact {
  int? id;
  String? nome;
  String? email;
  String? telefone;
  String? img;

  //metodo para converter um mapa em um objeto
  Contact.fromMap(Map<String, dynamic> map) {
    nome = map[nomeColumn];
    email = map[emailColumn];
    telefone = map[telefoneColumn];
    img = map[imgColumn];
  }

  //metodo para converter um objeto em um mapa
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact{id: $id, nome: $nome, email: $email, telefone: $telefone, img: $img}";
  }
}
