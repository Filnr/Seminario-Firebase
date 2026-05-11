String getAuthErrorMessage(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'Este e-mail já está cadastrado.';
    case 'weak-password':
      return 'A senha é muito fraca.';
    case 'user-not-found':
      return 'Usuário não encontrado.';
    case 'wrong-password':
      return 'Senha incorreta.';
    case 'invalid-email':
      return 'Formato de e-mail inválido.';
    case 'too-many-requests':
      return 'Muitas tentativas. Tente novamente mais tarde.';
    case 'network-request-failed':
      return 'Erro de conexão com a internet.';
    case 'user-disabled':
      return 'Esta conta foi desabilitada.';
    case 'google-sign-in-cancelled':
      return 'Login com Google cancelado.';
    case 'account-exists-with-different-credential':
      return 'Já existe uma conta com esse e-mail usando outro método de login.';
    default:
      return 'Erro de autenticação: $code';
  }
}