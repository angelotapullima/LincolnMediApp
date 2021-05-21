import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/citas_model.dart';
import 'package:form_validation/src/pages/atender_cita.dart';
import 'package:form_validation/src/pages/registro_cita.dart';

class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  DateTime today;
  String fecha;
  @override
  void initState() {
    today = toDateMonthYear(DateTime.now());
    fecha =
        "${today.year.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final citasBloc = Provider.citas(context);
    citasBloc.obtenerCitas(fecha);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.black,
            selectedTextColor: Colors.white,
            locale: 'es_ES',
            onDateChange: (date) {
              fecha =
                  "${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
              // New date selected
              citasBloc.obtenerCitas(fecha);

              print(fecha);
            },
          ),
          StreamBuilder(
            stream: citasBloc.emailStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<CitasModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (snapshot.data[index].estado == '9') {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return RegistroCita(
                                      fecha: '${snapshot.data[index].fecha}',
                                      hora: '${snapshot.data[index].hora}',
                                    );
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            } else if (snapshot.data[index].estado == '0') {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  opaque: false,
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return AtenderCita(
                                      idCita: snapshot.data[index].idCita,
                                      fecha: snapshot.data[index].fecha,
                                    );
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );

                              //atender cita
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ('${snapshot.data[index].estado}' == '9')
                                    ? Colors.black38
                                    : ('${snapshot.data[index].estado}' == '0')
                                        ? Colors.teal
                                        : Colors.red),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data[index].hora}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  '${snapshot.data[index].paNombre}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  '${snapshot.data[index].medico}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return CupertinoActivityIndicator();
                }
              } else {
                return CupertinoActivityIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  DateTime toDateMonthYear(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
