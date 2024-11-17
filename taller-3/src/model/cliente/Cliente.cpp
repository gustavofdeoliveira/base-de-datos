#include "Cliente.h"

Cliente Cliente::autenticarUsuario(pqxx::connection& conn, const std::string& email, const std::string& contrasena) {
    pqxx::work w(conn);
    std::string query = "SELECT * FROM cliente WHERE email = '" + email + "' AND contrasena = '" + contrasena + "'";
    pqxx::result r = w.exec(query);

    if (r.empty()) {
        throw std::runtime_error("Credenciais inválidas.");
    }

    Cliente cliente(r[0][0].as<int>(), r[0][1].as<std::string>(), r[0][2].as<std::string>(),
                   r[0][3].as<std::string>(), r[0][4].as<std::string>(), r[0][5].as<std::string>(),
                   r[0][6].as<std::string>());
    return cliente;
}
