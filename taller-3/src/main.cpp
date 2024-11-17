#include "model/sistema-banco/SistemaBanco.h"

int main() {
    SistemaBanco sistema("dbname=banco user=postgres password=1234");

    sistema.iniciarSesion();

    return 0;
}
