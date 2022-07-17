import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import '../modelos/modelos.dart';

class PromocionItemVista extends StatefulWidget {
  final Function(PromocionItem) onCreate;
  final Function(PromocionItem, int) onUpdate;
  final PromocionItem? originalItem;
  final int index;
  final bool isUpdating;

  static MaterialPage page({
    PromocionItem? item,
    int index = -1,
    required Function(PromocionItem) onCreate,
    required Function(PromocionItem, int) onUpdate,
  }) {
    return MaterialPage(
      name: ElPregoneroPaginas.promocionItemDetalles,
      key: ValueKey(ElPregoneroPaginas.promocionItemDetalles),
      child: PromocionItemVista(
        originalItem: item,
        index: index,
        onCreate: onCreate,
        onUpdate: onUpdate,
      ),
    );
  }

  const PromocionItemVista({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
    this.index = -1,
  })  : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _PromocionItemVistaState createState() => _PromocionItemVistaState();
}

class _PromocionItemVistaState extends State<PromocionItemVista> {
  final ImagePicker _picker = ImagePicker();
  File? _imagen;
  final _descripcionController = TextEditingController();
  final _pvpController = TextEditingController();
  final _descuentoController = TextEditingController();

  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final promocionItem = PromocionItem(
                id: widget.originalItem?.id ?? const Uuid().v1(),
                name: _descripcionController.text,
                importance: _importance,
                color: _currentColor,
                quantity: _currentSliderValue,
                date: DateTime(
                  _dueDate.year,
                  _dueDate.month,
                  _dueDate.day,
                  _timeOfDay.hour,
                  _timeOfDay.minute,
                ),
              );

              if (widget.isUpdating) {
                widget.onUpdate(promocionItem, widget.index);
              } else {
                widget.onCreate(promocionItem);
              }
            },
          )
        ],
        elevation: 0.0,
        title: Text(
          'Detalles de la Promoción',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildImagePicker(),
            const SizedBox(height: 20.0),
            buildCampoDescripcion(),
            buildCampoPVP(),
            buildCampoDescuento(),
            buildCampoVigenciaPromocion(context),
            const SizedBox(height: 20.0),
            buildEtiquetaColor(context),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  void imagePickerHelper({ImageSource source = ImageSource.gallery}) async {
    try {
      XFile? imagen = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear,
      );
      setState(() {
        _imagen = File(imagen!.path);
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagen',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        const SizedBox(height: 10.0),
        Center(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Fuente de la imagen'),
                        scrollable: true,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextButton(
                                child: const Text('Tomar una foto'),
                                onPressed: () => imagePickerHelper(
                                    source: ImageSource.camera)),
                            TextButton(
                                child: const Text('Elegir de la galería'),
                                onPressed: () => imagePickerHelper(
                                    source: ImageSource.gallery)),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _imagen != null ? Colors.transparent : Colors.indigo,
                  ),
                  child: _imagen != null
                      ? Image.file(
                          _imagen!,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.orange,
                          size: 50,
                        ),
                ),
              ),
              Text(
                'Adhiere una imagen',
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCampoDescripcion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        TextField(
          maxLength: 150,
          maxLines: 3,
          minLines: 1,
          controller: _descripcionController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
            hintText: 'De una descripción de la promoción.',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCampoPVP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Precio de Venta',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: _pvpController,
          cursorColor: _currentColor,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            //hintText: '9.99',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCampoDescuento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Porcentaje de Descuento',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: _descuentoController,
          cursorColor: _currentColor,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            //hintText: '25',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCampoVigenciaPromocion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vigencia',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            TextButton(
              child: const Text('Seleccionar'),
              onPressed: () async {
                final fechaActual = DateTime.now();
                final fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: fechaActual,
                  firstDate: fechaActual,
                  lastDate: DateTime(fechaActual.year + 1),
                );

                setState(() {
                  if (fechaSeleccionada != null) {
                    _dueDate = fechaSeleccionada;
                  }
                });
              },
            ),
          ],
        ),
        Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
      ],
    );
  }

  Widget buildEtiquetaColor(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 10,
              color: _currentColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Etiqueta de color',
              style: GoogleFonts.lato(fontSize: 28),
            ),
          ],
        ),
        TextButton(
          child: const Text('Seleccionar'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: BlockPicker(
                    pickerColor: Colors.white,
                    onColorChanged: (color) {
                      setState(() => _currentColor = color);
                    },
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
