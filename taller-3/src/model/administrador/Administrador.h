#ifndef ADMINISTRADOR_H
#define ADMINISTRADOR_H

#include "Cliente.h"
#include "Operacion.h"
#include <pqxx/pqxx>

class Administrador {
public:
    static void generarReportesFinancieros(pqxx::connection& conn);
    static void verCuentasInactivas(pqxx::connection& conn);
    static void gestionarUsuarios(pqxx::connection& conn);
};

#endif
