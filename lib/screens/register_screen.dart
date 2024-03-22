import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:pmsn2024/services/email_auth_firebase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Usuario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authFirebase = EmailAuthFirebase();
  final TextEditingController _conNameUser = TextEditingController();
  final TextEditingController _conEmailUser = TextEditingController();
  final TextEditingController _conPwdUser = TextEditingController();
  File? _avatarImage;

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _selectAvatarFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _avatarImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _captureAvatarFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _avatarImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Seleccionar Avatar"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: Text("Seleccionar de la Galería"),
                              onTap: () {
                                Navigator.pop(context);
                                _selectAvatarFromGallery();
                              },
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            GestureDetector(
                              child: Text("Capturar desde la Cámara"),
                              onTap: () {
                                Navigator.pop(context);
                                _captureAvatarFromCamera();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: _avatarImage != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(_avatarImage!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[600],
                      child: Icon(Icons.person, color: Colors.white),
                    ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _conNameUser,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _conEmailUser,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _conPwdUser,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
              ),
              onPressed: () {
                _saveUser(
                  _conNameUser.text,
                  _conEmailUser.text,
                  _conPwdUser.text,
                  _avatarImage,
                );
              },
              child: Text('Guardar Usuario'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _saveUser(
      String fullName, String email, String password, File? avatarImage) {
    if (_conNameUser.text.isEmpty ||
        _conEmailUser.text.isEmpty ||
        _conPwdUser.text.isEmpty ||
        _avatarImage == null) {
      _showDialog("Campos Incompletos", "Por favor, complete todos los campos.");
    } else if (!isValidEmail(_conEmailUser.text)) {
      _showDialog("Correo Electrónico Inválido", "Por favor, ingrese un correo electrónico válido.");
    } else {
      authFirebase.signUpUser(
        name: _conNameUser.text,
        password: _conPwdUser.text,
        email: _conEmailUser.text,
      ).then((value) {
        if (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Se registró el usuario.'),
            ),
          );
          _clearFields();
        } else {
          _showDialog("Error", "No se pudo registrar el usuario. Inténtelo de nuevo más tarde.");
        }
      });
    }
  }

  void _clearFields() {
    _conNameUser.clear();
    _conEmailUser.clear();
    _conPwdUser.clear();
    setState(() {
      _avatarImage = null;
    });
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}


