#ifndef OPERACION_H
#define OPERACION_H

#include <string>
#include <pqxx/pqxx>

class Operacion {
private:
    int id;
    float valor;
    std::string tipo;
    std::string status;
    int id_cliente;
    int id_cuenta;

public:
    Operacion(int id, float valor, const std::string& tipo, const std::string& status,
              int id_cliente, int id_cuenta)
        : id(id), valor(valor), tipo(tipo), status(status), id_cliente(id_cliente), id_cuenta(id_cuenta) {}

    void registrarOperacion(pqxx::connection& conn);
    static void mostrarHistorialTransacciones(pqxx::connection& conn, int id_cliente);
};

#endif
