import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final TextEditingController _conNameUser = TextEditingController();
  final TextEditingController _conEmailUser = TextEditingController();
  final TextEditingController _conPwdUser = TextEditingController();
  File? _avatarImage;

  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                if (_conNameUser.text.isEmpty ||
                    _conEmailUser.text.isEmpty ||
                    _conPwdUser.text.isEmpty ||
                    _avatarImage == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Campos Incompletos"),
                        content: Text("Por favor, complete todos los campos"),
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
                } else if (!isValidEmail(_conEmailUser.text)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Correo Electrónico Inválido"),
                        content: Text("Por favor, ingrese un correo electrónico válido."),
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
                } else {
                  String fullName = _conNameUser.text;
                  String email = _conEmailUser.text;
                  String password = _conPwdUser.text;
                  _saveUser(fullName, email, password, _avatarImage);
                  _conNameUser.clear();
                  _conEmailUser.clear();
                  _conPwdUser.clear();
                  setState(() {
                    _avatarImage = null;
                  });
                }
              },
              child: Text('Guardar Usuario'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _saveUser(String fullName, String email, String password, File? avatarImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Éxito"),
          content: Text("Usuario creado exitosamente."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}











