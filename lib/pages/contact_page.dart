import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agenda_de_contatos/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editedContact;
  bool _userEdited = false;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
      _editedContact.nome = "Joao";
      _editedContact.email = "john.c.breckinridge@altostrat.com";
      _editedContact.telefone = "123456789";
      _editedContact.img = "";
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedContact.nome ?? "Novo Contato",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.img.isNotEmpty
                          ? FileImage(File(_editedContact.img))
                          : const AssetImage("images/kindpng_338711.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onChanged: (text) {
                  setState(() {
                    _userEdited = true;
                    _editedContact.nome = text;
                  });
                },
              ),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                    ),
                    onChanged: (text) {
                      setState(() {
                        _userEdited = true;
                        _editedContact.email = text;
                      });
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Telefone",
                    ),
                    onChanged: (text) {
                      setState(() {
                        _userEdited = true;
                        _editedContact.telefone = text;
                      });
                    },
                  ),
            ]),
          )),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}
