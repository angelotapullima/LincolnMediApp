import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/models/paciente_model.dart';
import 'package:form_validation/src/providers/pacientes_provider.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class PacientePage extends StatefulWidget {
  @override
  _PacientePageState createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final pacientesProvider = new PacientesProvider();

  PacienteModel paciente = new PacienteModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final PacienteModel paciData = ModalRoute.of(context).settings.arguments;
    if (paciData != null) {
      paciente = paciData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Paciente'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
            // onPressed: (){},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearDni(),
                _crearNombre(),
                _crearApellido(),
                _crearNumero(),
                _crearCorreo(),
                SizedBox(height: 20),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearDni() {
    return TextFormField(
      initialValue: paciente.carnet.toString(),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Dni'),
      onSaved: (value) => paciente.carnet = value,
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Ingrese solo números';
        }
      },
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: paciente.name,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Nombres'),
      onSaved: (value) => paciente.name = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese nombre completo';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearApellido() {
    return TextFormField(
      initialValue: paciente.lastname,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Apellidos'),
      onSaved: (value) => paciente.lastname = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese apellido completo';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearNumero() {
    return TextFormField(
      initialValue: paciente.number.toString(),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Celular'),
      onSaved: (value) => paciente.number = value,
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Ingrese solo números';
        }
      },
    );
  }

  Widget _crearCorreo() {
    return TextFormField(
      initialValue: paciente.direccion,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Correo'),
      onSaved: (value) => paciente.direccion = value,
      // validator: (value) {
      //   if (value.length < 4) {
      //     return 'Ingrese email completo';
      //   } else {
      //     return null;
      //   }
      // },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      //padding: EdgeInsets.only(top: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.teal,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      paciente.fotoUrl = await pacientesProvider.subirImagen(foto);
    }

    if (paciente.id == null) {
      pacientesProvider.crearPaciente(paciente);
    } else {
      pacientesProvider.editarPaciente(paciente);
    }

    mostrarSnackbar('Paciente Registrado');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
    if (paciente.fotoUrl != null) {
      return Container(
        child: FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(paciente.fotoUrl),
          fit: BoxFit.contain,
        ),
        height: 250.0,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: origen,
    );

    foto = File(pickedFile.path);

    if (foto != null) {
      paciente.fotoUrl = null;
    }

    setState(() {});
  }

  // _seleccionarFoto() async {
  //   _procesarImagen(ImageSource.gallery);

  // }

  // _tomarFoto() async {
  //   _procesarImagen(ImageSource.camera);

  // }

  // _procesarImagen(ImageSource origen) async {
  //   foto = await ImagePicker.pickImage(source: origen);
  //   if (foto != null) {
  //     paciente.fotoUrl = null;
  //   }

  //   setState(() {});
  // }

}
