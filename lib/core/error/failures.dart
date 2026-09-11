sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super(
            'Pas de connexion internet. Données locales utilisées si disponibles.');
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure() : super('Aucune donnée en cache disponible.');
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
