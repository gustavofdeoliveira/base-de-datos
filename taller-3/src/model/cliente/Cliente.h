#ifndef CLIENTE_H
#define CLIENTE_H

#include <string>
#include <pqxx/pqxx>

class Cliente {
private:
    int rut;
    std::string nombre;
    std::string direccion;
    std::string email;
    std::string telefone;
    std::string contrasena;
    std::string tipo;  // Cliente o administrador

public:
    Cliente(int rut, std::string nombre, std::string direccion, std::string email,
            std::string telefone, std::string contrasena, std::string tipo)
        : rut(rut), nombre(nombre), direccion(direccion), email(email),
          telefone(telefone), contrasena(contrasena), tipo(tipo) {}

    int getRut() const { return rut; }
    std::string getNombre() const { return nombre; }
    std::string getEmail() const { return email; }
    std::string getTipo() const { return tipo; }

    // Metodo de autenticação
    static Cliente autenticarUsuario(pqxx::connection& conn, const std::string& email, const std::string& contrasena);
};

#endif
