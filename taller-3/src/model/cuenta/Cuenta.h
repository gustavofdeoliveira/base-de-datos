#ifndef CUENTA_H
#define CUENTA_H

#include <iostream>
#include <pqxx/pqxx>

class Cuenta {
private:
    int numero;
    float saldo;
    int id_cliente;

public:
    Cuenta(int numero, float saldo, int id_cliente)
        : numero(numero), saldo(saldo), id_cliente(id_cliente) {}

    int getNumero() const { return numero; }
    float getSaldo() const { return saldo; }
    int getIdCliente() const { return id_cliente; }

    void realizarDeposito(pqxx::connection& conn, float monto);
    bool realizarRetiro(pqxx::connection& conn, float monto);
    bool realizarTransferencia(pqxx::connection& conn, Cuenta& cuentaDestino, float monto);
};

#endif
