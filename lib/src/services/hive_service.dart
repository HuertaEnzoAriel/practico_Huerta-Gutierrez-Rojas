import 'dart:io';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cliente.dart';
import '../models/producto.dart';
import '../models/pedido.dart';

class HiveService {
  // Acceso a las cajas abiertas en el main
  static Box<Cliente> get clientes => Hive.box<Cliente>('clientes');
  static Box<Producto> get productos => Hive.box<Producto>('productos');
  static Box<Pedido> get pedidos => Hive.box<Pedido>('pedidos');

  // Genera un ID único a partir de la fecha y hora
  static String nuevoId() => DateTime.now().microsecondsSinceEpoch.toString();

  // Copia la imagen a una carpeta permanente: la ruta del picker es temporal
  static Future<String> guardarImagen(File imagen) async {
    final carpeta = await getApplicationDocumentsDirectory();
    final copia = await imagen.copy('${carpeta.path}/${nuevoId()}');
    return copia.path;
  }

  // ---------- CLIENTES ----------
  static List<Cliente> obtenerClientes() => clientes.values.toList();

  static Future<void> guardarCliente(Cliente c) async {
    c.id ??= nuevoId(); // si es nuevo, le asigna un ID
    await clientes.put(c.id, c); // put crea o actualiza

    // El pedido guarda una copia del nombre: la mantenemos al día
    final pedidosDelCliente = pedidos.values
        .where((p) => p.idCliente == c.id && p.nombreCliente != c.nombre)
        .toList();
    for (final p in pedidosDelCliente) {
      p.nombreCliente = c.nombre;
      await pedidos.put(p.id, p);
    }
  }

  static Future<void> borrarCliente(String id) => clientes.delete(id);

  // ---------- PRODUCTOS ----------
  static List<Producto> obtenerProductos() => productos.values.toList();

  static Future<void> guardarProducto(Producto p) async {
    p.id ??= nuevoId();
    await productos.put(p.id, p);
  }

  static Future<void> borrarProducto(String id) => productos.delete(id);

  // ---------- PEDIDOS ----------
  static List<Pedido> obtenerPedidos() => pedidos.values.toList();

  static Future<void> guardarPedido(Pedido p) async {
    p.id ??= nuevoId();
    await pedidos.put(p.id, p);
  }

  static Future<void> borrarPedido(String id) => pedidos.delete(id);
}
