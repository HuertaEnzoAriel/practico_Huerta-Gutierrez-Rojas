import 'package:hive_ce/hive.dart';
import '../models/cliente.dart';
import '../models/producto.dart';
import '../models/pedido.dart';
import '../models/itemproducto.dart';

@GenerateAdapters([
  AdapterSpec<Cliente>(),
  AdapterSpec<Producto>(),
  AdapterSpec<ItemProducto>(),
  AdapterSpec<Pedido>(),
])
part 'hive_adapters.g.dart';