import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/providers/citas_provider.dart';
import 'package:form_validation/src/utils/responsive.dart';

class AtenderCita extends StatefulWidget {
  const AtenderCita({Key key, @required this.idCita,@required this.fecha}) : super(key: key);

  final String idCita;
  final String fecha;

  @override
  _AtenderCitaState createState() => _AtenderCitaState();
}

class _AtenderCitaState extends State<AtenderCita> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.5),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.wp(5),
              ),
              width: double.infinity,
              height: responsive.hp(37),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                      height: responsive.hp(15),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/logo.jpeg'),
                        radius: responsive.ip(6),
                      )

                      //Image.asset('assets/logo.jpeg'),
                      ),
                  Container(
                    height: responsive.hp(11),
                    child: Center(
                      child: Text(
                        'Estás seguro de atender esta cita',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  Container(
                    height: responsive.hp(5),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final citasProvider = CitasProvider();
                            final res =
                                await citasProvider.atenderCita(widget.idCita);

                            if (res) {
                              Navigator.pop(context);
                      final citasBloc = Provider.citas(context);
                      citasBloc.obtenerCitas(widget.fecha);
                            } else {}
                          },
                          child: Container(
                            width: responsive.wp(43),
                            child: Text(
                              'Aceptar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          width: responsive.wp(.2),
                          color: Colors.green,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: responsive.wp(43),
                            child: Text(
                              'Cancelar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
