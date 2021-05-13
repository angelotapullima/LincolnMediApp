import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/paciente_model.dart';
import 'package:form_validation/src/providers/pacientes_provider.dart';

class HomePage extends StatelessWidget {
  final pacientesProvider = new PacientesProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Pacientes'),
      //   centerTitle: true,
      // ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: pacientesProvider.cargarPacientes(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PacienteModel>> snapshot) {
        if (snapshot.hasData) {
          final pacientes = snapshot.data;

          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, i) => _crearItem(context, pacientes[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, PacienteModel paciente) {
    // return Container(
    //   child: _card(context, paciente),
    // );
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {
        pacientesProvider.borrarPaciente(paciente.id);
      },
      child: _card(context, paciente),
    );
  }

  Widget _card(BuildContext context, PacienteModel paciente) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            alignment: Alignment.topCenter,
            child: Text('${paciente.name}',
                style: TextStyle(fontSize: 25, color: Colors.black),
                textAlign: TextAlign.center),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: (paciente.fotoUrl == null)
                    ? CircleAvatar(
                        backgroundImage: AssetImage('assets/no-image.png'),
                        radius: 45.0,
                      )
                    // ? Image(image: AssetImage('assets/no-image.png'))
                    : CircleAvatar(
                        backgroundColor: Colors.black26,
                        backgroundImage: NetworkImage(paciente.fotoUrl),
                        radius: 45.0,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 15, bottom: 3),
                      child: Text('${paciente.lastname}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400))),
                  Container(
                      padding: EdgeInsets.only(left: 15, bottom: 3),
                      child: Text('${paciente.carnet}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400))),
                  // SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(left: 15, bottom: 3),
                      // alignment: Alignment.centerLeft,
                      child: Text('${paciente.number}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400))),
                  // SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      alignment: Alignment.bottomRight,
                      child: Text('${paciente.direccion}',
                          style: TextStyle(fontSize: 15, color: Colors.grey))),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),

                //Text('Editar'),
                onPressed: () => Navigator.pushNamed(context, 'paciente',
                    arguments: paciente),
              ),
              // FlatButton(
              //   child: Icon(
              //     Icons.note,
              //     color: Colors.amber,
              //   ),

              //   // Text('Editar'),
              //   onPressed: null,
              // ),
              // FlatButton(
              //   child: Icon(
              //     Icons.delete,
              //     color: Colors.red,
              //   ),
              //   onPressed: () => _dialogo,
                // Text('Editar'),
                // onPressed: () => ( pacientesProvider.borrarPaciente(paciente.id)),
              // )
            ],
          )
        ],
      ),
    );
  }

  // void _dialogo(BuildContext context, PacienteModel paciente) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //           title: Text('Alerta'),
  //           content: Text('¿Estas seguro de eliminar el paciente?'),
  //           actions: <Widget>[
  //             FlatButton(child: Text('Cancelar'),onPressed: () => Navigator.of(context).pop()),
  //             FlatButton(onPressed: null, child: Text('OK'))
  //           ],
  //         );
  //       });
  // }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.teal,
      onPressed: () => Navigator.pushNamed(context, 'paciente'),
    );
  }
}
