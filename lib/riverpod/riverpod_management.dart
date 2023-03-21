import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dietic_mobil/riverpod/register_riverpod.dart';
import '../riverpod/login_riverpod.dart';


final loginRiverpod = ChangeNotifierProvider((_) => LoginRiverpod());
final registerRiverpod = ChangeNotifierProvider((_) => RegisterRiverpod());

