#include "SistemaBanco.h"
#include <iostream>
#include <limits>

SistemaBanco::SistemaBanco(const std::string& connection_info) : conn(connection_info) {}

void SistemaBanco::iniciarSesion() {
    std::string email, contrasena;
    std::cout << "Ingrese su email: ";
    std::cin >> email;
    std::cout << "Ingrese su contrasena: ";
    std::cin >> contrasena;

    try {
        Cliente cliente = Cliente::autenticarUsuario(conn, email, contrasena);
        if (cliente.getTipo() == "administrador") {
            Administrador admin;
            menuAdministrador(admin);
        } else {
            menuCliente(cliente);
        }
    } catch (const std::exception& e) {
        std::cout << "Error: " << e.what() << std::endl;
    }
}

void SistemaBanco::menuCliente(Cliente& cliente) {
    int opcao;
    std::cout << "\nBienvenido, " << cliente.getNombre() << "!" << std::endl;
    std::cout << "1. Consultar saldo" << std::endl;
    std::cout << "2. Realizar deposito" << std::endl;
    std::cout << "3. Realizar retiro" << std::endl;
    std::cout << "4. Realizar transferencia" << std::endl;
    std::cout << "5. Consultar historial de transacciones" << std::endl;
    std::cout << "6. Salir" << std::endl;
    std::cout << "Seleccione una opcion: ";
    std::cin >> opcao;

    // Obtenção de conta do cliente (simulação simples)
    Cuenta conta(12345, 1000.0, cliente.getRut());

    switch (opcao) {
        case 1:
            consultarSaldo(conta);
            break;
        case 2:
            realizarDeposito(conta);
            break;
        case 3:
            realizarRetiro(conta);
            break;
        case 4:
            realizarTransferencia(conta);
            break;
        case 5:
            consultarHistoricoTransacoes(cliente);
            break;
        case 6:
            std::cout << "Cerrando sesión..." << std::endl;
            break;
        default:
            std::cout << "Opción no válida, por favor intente nuevamente." << std::endl;
    }
}

void SistemaBanco::menuAdministrador(Administrador& administrador) {
    int opcao;
    std::cout << "\nBienvenido Administrador!" << std::endl;
    std::cout << "1. Generar reporte financiero" << std::endl;
    std::cout << "2. Ver cuentas inactivas" << std::endl;
    std::cout << "3. Gestionar usuarios" << std::endl;
    std::cout << "4. Salir" << std::endl;
    std::cout << "Seleccione una opcion: ";
    std::cin >> opcao;

    switch (opcao) {
        case 1:
            gerarRelatorioFinanceiro();
            break;
        case 2:
            verContasInativas();
            break;
        case 3:
            listarUsuarios();
            break;
        case 4:
            std::cout << "Cerrando sesión..." << std::endl;
            break;
        default:
            std::cout << "Opción no válida, por favor intente nuevamente." << std::endl;
    }
}

void SistemaBanco::realizarDeposito(Cuenta& conta) {
    float monto;
    std::cout << "Ingrese el monto a depositar: ";
    std::cin >> monto;

    if (monto > 0) {
        conta.realizarDeposito(conn, monto);
        std::cout << "Depósito realizado con éxito." << std::endl;
    } else {
        std::cout << "El monto ingresado es inválido." << std::endl;
    }
}

void SistemaBanco::realizarRetiro(Cuenta& conta) {
    float monto;
    std::cout << "Ingrese el monto a retirar: ";
    std::cin >> monto;

    if (monto > 0 && !conta.realizarRetiro(conn, monto)) {
        std::cout << "Retiro fallido. Saldo insuficiente." << std::endl;
    }
}

void SistemaBanco::realizarTransferencia(Cuenta& conta) {
    int numeroDestino;
    float monto;
    std::cout << "Ingrese el número de cuenta destino: ";
    std::cin >> numeroDestino;
    std::cout << "Ingrese el monto a transferir: ";
    std::cin >> monto;

    // Obtenção de conta destino (simulação simples)
    Cuenta contaDestino(numeroDestino, 500.0, conta.getIdCliente());

    if (!conta.realizarTransferencia(conn, contaDestino, monto)) {
        std::cout << "Transferencia fallida. Saldo insuficiente." << std::endl;
    } else {
        std::cout << "Transferencia realizada con éxito." << std::endl;
    }
}

void SistemaBanco::consultarSaldo(Cuenta& conta) {
    std::cout << "El saldo de su cuenta es: " << conta.getSaldo() << " unidades." << std::endl;
}

void SistemaBanco::consultarHistoricoTransacoes(Cliente& cliente) {
    Operacion::mostrarHistorialTransacciones(conn, cliente.getRut());
}

void SistemaBanco::gerarRelatorioFinanceiro() {
    Administrador::generarReportesFinancieros(conn);
}

void SistemaBanco::verContasInativas() {
    Administrador::verCuentasInactivas(conn);
}

void SistemaBanco::listarUsuarios() {
    Administrador::gestionarUsuarios(conn);
}
