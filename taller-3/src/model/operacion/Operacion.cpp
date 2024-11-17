#include "Operacion.h"

void Operacion::registrarOperacion(pqxx::connection& conn) {
    pqxx::work w(conn);
    std::string query = "INSERT INTO operacion_financeira (valor, tipo, status, id_cliente, id_cuenta) "
                        "VALUES (" + std::to_string(valor) + ", '" + tipo + "', '" + status + "', "
                        + std::to_string(id_cliente) + ", " + std::to_string(id_cuenta) + ")";
    w.exec(query);
    w.commit();
}

void Operacion::mostrarHistorialTransacciones(pqxx::connection& conn, int id_cliente) {
    pqxx::work w(conn);
    std::string query = "SELECT * FROM operacion_financeira WHERE id_cliente = " + std::to_string(id_cliente);
    pqxx::result r = w.exec(query);

    for (auto row : r) {
        std::cout << "ID: " << row[0].as<int>() << ", Tipo: " << row[5].as<std::string>() << ", Status: "
                  << row[6].as<std::string>() << ", Valor: " << row[1].as<float>() << std::endl;
    }
}
