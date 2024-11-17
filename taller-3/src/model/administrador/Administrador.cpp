#include "Administrador.h"

void Administrador::generarReportesFinancieros(pqxx::connection& conn) {
    pqxx::work w(conn);
    std::string query = "SELECT AVG(saldo), COUNT(*), SUM(saldo) FROM cuenta";
    pqxx::result r = w.exec(query);
    std::cout << "Saldo promedio: " << r[0][0].as<float>() << std::endl;
    std::cout << "Número de cuentas: " << r[0][1].as<int>() << std::endl;
    std::cout << "Total de saldos: " << r[0][2].as<float>() << std::endl;
}

void Administrador::verCuentasInactivas(pqxx::connection& conn) {
    pqxx::work w(conn);
    std::string query = "SELECT * FROM cuenta WHERE fecha_creacion < CURRENT_DATE - INTERVAL '6 months'";
    pqxx::result r = w.exec(query);

    for (auto row : r) {
        std::cout << "Cuenta inactiva: " << row[0].as<int>() << ", Cliente: " << row[3].as<int>() << std::endl;
    }
}

void Administrador::gestionarUsuarios(pqxx::connection& conn) {
    pqxx::work w(conn);
    std::string query = "SELECT * FROM cliente";
    pqxx::result r = w.exec(query);

    for (auto row : r) {
        std::cout << "ID: " << row[0].as<int>() << ", Nombre: " << row[1].as<std::string>()
                  << ", Email: " << row[3].as<std::string>() << std::endl;
    }
}
