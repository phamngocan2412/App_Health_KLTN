import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../../features/chat_ai/controllers/chat_repository.dart';


final chatProvider = Provider(
  (ref) => ChatRepository(),
);

final authProvider = Provider(
  (ref) => AuthenticationRepository(),
);