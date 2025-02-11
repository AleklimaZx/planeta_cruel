
class Planeta {
  int? id;
  String nome;
  double distanciaSol;
  double tamanho;
  String? apelido;

  Planeta({
    this.id,
    required this.nome,
    required this.distanciaSol,
    required this.tamanho,
    this.apelido,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'distanciaSol': distanciaSol,
      'tamanho': tamanho,
      'apelido': apelido,
    };
  }

  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      distanciaSol: map['distanciaSol'],
      tamanho: map['tamanho'],
      apelido: map['apelido'],
    );
  }
}
