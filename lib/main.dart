import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'src/app.dart';
import 'src/hive/hive_registrar.g.dart';
import 'src/models/cliente.dart';
import 'src/models/producto.dart';
import 'src/models/pedido.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Iniciar Hive en la carpeta de datos de la app
  await Hive.initFlutter();

  // 2. Registrar los 4 adaptadores generados en el paso 2
  Hive.registerAdapters();

  // 3. Abrir una caja por cada modelo principal
  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Producto>('productos');
  await Hive.openBox<Pedido>('pedidos');

  runApp(const DimeelprecioApp());
}
