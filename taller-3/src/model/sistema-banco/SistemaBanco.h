#ifndef SISTEMA_BANCO_H
#define SISTEMA_BANCO_H

#include "../cliente/Cliente.h"
#include "../cuenta/Cuenta.h"
#include "../operacion/Operacion.h"
#include "../administrador/Administrador.h"
#include <pqxx/pqxx>

class SistemaBanco {
private:
    pqxx::connection conn;

public:
    SistemaBanco(const std::string& connection_info);

    void iniciarSesion();
    void menuCliente(Cliente& cliente);
    void menuAdministrador(Administrador& administrador);
    void registrarUsuario();
    void realizarDeposito(Cuenta& cuenta);
    void realizarRetiro(Cuenta& conta);
    void realizarTransferencia(Cuenta& cuenta);
    void consultarSaldo(Cuenta& conta);
    void consultarHistoricoTransacoes(Cliente& cliente);
    void gerarRelatorioFinanceiro();
    void verContasInativas();
    void listarUsuarios();
};

#endif
