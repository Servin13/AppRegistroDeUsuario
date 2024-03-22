import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn2024/database/products_database.dart';
import 'package:pmsn2024/model/products_model.dart';
import 'package:pmsn2024/setting/app_value_notifier.dart';

class DespensaScreen extends StatefulWidget {
  const DespensaScreen({super.key});

  @override
  State<DespensaScreen> createState() => _DespensaScreenState();
}

class _DespensaScreenState extends State<DespensaScreen> {
  ProductsDatabase? productsDB; //Late o ? no es nulo

  @override
  void initState() {
    super.initState();
    productsDB = new ProductsDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi despensa'),
        actions: [
          IconButton(
              onPressed: () {
                showModal(context, null);
              },
              icon: const Icon(Icons.add_task))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: AppValueNotifier.banProducts,
          builder: (context, value, _) {
            return FutureBuilder(
              future: productsDB!.CONSULTAR(),
              builder: (context, AsyncSnapshot<List<ProductosModel>> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Algo salio mal: '),
                  );
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return itemDespensa(snapshot.data![index]);
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            );
          }),
    );
  }

  Widget itemDespensa(ProductosModel producto) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          )),
      height: 100,
      child: Column(
        children: [
          //Como interpolar entre objeto y producto
          Text('${producto.nomProducto!}'),
          Text('${producto.fechaCaducidad!}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    showModal(context, producto);
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    ArtDialogResponse response = await ArtSweetAlert.show(
                        barrierDismissible: false,
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                            denyButtonText: "Cancelar",
                            title: "Estas seguro?",
                            text: "No podrás revertir esto!",
                            confirmButtonText: "Si, eliminar producto",
                            type: ArtSweetAlertType.warning));

                    if (response == null) {
                      return;
                    }

                    if (response.isTapConfirmButton) {
                      productsDB!.ELIMINAR(producto.idProducto!).then((value) {
                        if (value > 0) {
                          ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Producto eliminado!"));
                          AppValueNotifier.banProducts.value =
                              !AppValueNotifier.banProducts.value;
                        }
                      });
                      return;
                    }
                  },
                  icon: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }

  showModal(context, ProductosModel? producto) {
    //Controladores
    final conNombre = TextEditingController();
    final conCantidad = TextEditingController();
    final conFecha = TextEditingController();

    if (producto != null) {
      conNombre.text = producto.nomProducto!;
      conCantidad.text = producto.canProducto!.toString();
      conFecha.text = producto.fechaCaducidad!;
    }

    final txtNombre = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombre,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final txtCantidad = TextFormField(
      keyboardType: TextInputType.number,
      controller: conCantidad,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final btnAgregar = ElevatedButton.icon(
        onPressed: () {
          if (producto == null) {
            productsDB!.INSERTAR({
              "nomProducto": conNombre.text,
              "canProducto": int.parse(conCantidad.text),
              "fechaCaducidad": conFecha.text
            }).then((value) {
              Navigator.pop(context);
              String msj = "";
              if (value > 0) {
                AppValueNotifier.banProducts.value = !AppValueNotifier
                    .banProducts
                    .value; //Se hace la negacion para los cambios de estado true o false
                msj = "Producto insertado";
              } else {
                msj = "Ocurrio un error !!!";
              }
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
          } else {
            productsDB!.ACTUALIZAR({
              "idProducto": producto.idProducto,
              "nomProducto": conNombre.text,
              "canProducto": int.parse(conCantidad.text),
              "fechaCaducidad": conFecha.text
            }).then((value) {
              Navigator.pop(context);
              String msj = "";
              if (value > 0) {
                AppValueNotifier.banProducts.value = !AppValueNotifier
                    .banProducts
                    .value; //Se hace la negacion para los cambios de estado true o false
                msj = "Producto Actualizado";
              } else {
                msj = "Ocurrio un error !!!";
              }
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
          }
        },
        icon: const Icon(Icons.save),
        label: const Text('Guardar producto'));

    final space = SizedBox(
      height: 10,
    );

    final txtFecha = TextFormField(
      controller: conFecha,
      keyboardType: TextInputType.none, //Ocultamos el teclado
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onTap: () async {
        //Siempre que lleve un await llevara un async
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(
              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
          setState(() {
            conFecha.text =
                formattedDate; //set foratted date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    );

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              txtNombre,
              space,
              txtCantidad,
              space,
              txtFecha,
              space,
              btnAgregar
            ],
          );
        });
  }
}
