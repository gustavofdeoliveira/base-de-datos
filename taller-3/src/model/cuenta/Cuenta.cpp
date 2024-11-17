#include "Cuenta.h"

void Cuenta::realizarDeposito(pqxx::connection& conn, float monto) {
    saldo += monto;
    pqxx::work w(conn);
    std::string query = "UPDATE cuenta SET saldo = " + std::to_string(saldo) + " WHERE numero = " + std::to_string(numero);
    w.exec(query);
    w.commit();
}

bool Cuenta::realizarRetiro(pqxx::connection& conn, float monto) {
    if (saldo >= monto) {
        saldo -= monto;
        pqxx::work w(conn);
        std::string query = "UPDATE cuenta SET saldo = " + std::to_string(saldo) + " WHERE numero = " + std::to_string(numero);
        w.exec(query);
        w.commit();
        return true;
    } else {
        std::cout << "Saldo insuficiente para realizar el retiro.\n";
        return false;
    }
}

bool Cuenta::realizarTransferencia(pqxx::connection& conn, Cuenta& cuentaDestino, float monto) {
    if (realizarRetiro(conn, monto)) {
        cuentaDestino.realizarDeposito(conn, monto);
        return true;
    }
    return false;
}
