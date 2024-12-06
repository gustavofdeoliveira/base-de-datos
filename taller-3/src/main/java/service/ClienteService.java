package service;

import dao.ClienteDAO;
import dao.CuentaDAO;
import dao.OperacionFinanceiraDAO;
import model.ClienteModel;
import model.CuentaModel;
import model.OperacionFinanceiraModel;

import java.util.Scanner;

public class ClienteService {
    private static ClienteDAO clienteDAO = new ClienteDAO();
    private static CuentaDAO cuentaDAO = new CuentaDAO();
    private static OperacionFinanceiraDAO operacionFinanceiraDAO = new OperacionFinanceiraDAO();

    private static void menuCliente(ClienteModel cliente, Scanner scanner) {
        boolean showMenu = true;
        while (showMenu) {
            System.out.println("\n=== Menú Cliente ===");
            System.out.println("¡Bienvenido, " + cliente.getNombre() + "!");
            System.out.println("1. Realizar depósito");
            System.out.println("2. Realizar retiro");
            System.out.println("3. Realizar transferencia");
            System.out.println("4. Consultar saldo");
            System.out.println("5. Salir");
            System.out.print("Seleccione una opción: ");
            int opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1:
                    registrarDeposito(scanner, cliente);
                    break;
                case 2:
                    realizarRetiro(scanner, cliente);
                    break;
                case 3:
                    realizarTransferencia(scanner, cliente);
                    break;
                case 4:
                    consultarSaldo(cliente);
                    break;
                case 5:
                    System.out.println("Saliendo...");
                    showMenu = false;
                    break;
                default:
                    System.out.println("Opción inválida. Intente de nuevo.");
            }
        }
    }

    public static void iniciarSesion(Scanner scanner) {
        System.out.print("Correo electrónico: ");
        String email = scanner.nextLine();
        System.out.print("Contraseña: ");
        String contrasena = scanner.nextLine();

        ClienteModel cliente = clienteDAO.iniciarSesion(email, contrasena);
        if (cliente != null) {
            if (cliente.getTipo().equalsIgnoreCase("administrador")) {
                AdministradorService.menuAdministrador(cliente, scanner);
            } else {
                menuCliente(cliente, scanner);
            }
        } else {
            System.out.println("Credenciales inválidas. Intente de nuevo.");
        }
    }

    public static void registrarse(Scanner scanner) {
        System.out.print("RUT: ");
        int rut = scanner.nextInt();
        scanner.nextLine();
        System.out.print("Nombre: ");
        String nombre = scanner.nextLine();
        System.out.print("Dirección: ");
        String direccion = scanner.nextLine();
        System.out.print("Correo electrónico: ");
        String email = scanner.nextLine();
        System.out.print("Teléfono: ");
        String telefono = scanner.nextLine();
        System.out.print("Contraseña: ");
        String contrasena = scanner.nextLine();

        ClienteModel nuevoCliente = new ClienteModel(rut, nombre, direccion, email, telefono, contrasena, "cliente");
        if (clienteDAO.registrarCliente(nuevoCliente)) {
            CuentaModel nuevaCuenta = new CuentaModel(nuevoCliente.getRut(), 1000, null, nuevoCliente.getRut());
            if (cuentaDAO.registrarCuenta(nuevaCuenta)) {
                System.out.println("¡Registro exitoso!");
            } else {
                System.out.println("Error al registrar al cuenta.");
            }
        } else {
            System.out.println("Error al registrar al cliente.");
        }
    }

    public static void registrarDeposito(Scanner scanner, ClienteModel cliente) {
        System.out.print("Ingrese el valor del depósito: ");
        float valor = scanner.nextFloat();
        scanner.nextLine();

        OperacionFinanceiraModel operacion = new OperacionFinanceiraModel(
                null, valor, null, cliente.getRut(), cliente.getRut(), "depósito", "creado", cliente.getRut()
        );

        if (operacionFinanceiraDAO.registrarOperacion(operacion)) {
            System.out.println("¡Depósito realizado con éxito!");
        } else {
            System.out.println("Error al realizar el depósito.");
        }
    }

    private static void realizarRetiro(Scanner scanner, ClienteModel cliente) {
        System.out.print("Ingrese el valor del retiro: ");
        float valor = scanner.nextFloat();
        scanner.nextLine();

        CuentaModel cuenta = cuentaDAO.consultarCuentaPorNumero(cliente.getRut());
        if (cuenta == null || cuenta.getSaldo() < valor) {
            System.out.println("Saldo insuficiente o cuenta no encontrada.");
            return;
        }

        OperacionFinanceiraModel operacion = new OperacionFinanceiraModel(
                null, valor, null, cliente.getRut(), cliente.getRut(), "retiro", "finalizado", cliente.getRut()
        );

        if (operacionFinanceiraDAO.registrarOperacion(operacion)) {
            System.out.println("¡Retiro realizado con éxito!");
        } else {
            System.out.println("Error al realizar el retiro.");
        }
    }

    private static void realizarTransferencia(Scanner scanner, ClienteModel cliente) {
        System.out.print("Ingrese el numero de la cuenta destino: ");
        int cuentaDestino = scanner.nextInt();
        System.out.print("Ingrese el valor de la transferencia: ");
        float valor = scanner.nextFloat();
        scanner.nextLine();

        CuentaModel cuentaOrigen = cuentaDAO.consultarCuentaPorNumero(cliente.getRut());
        CuentaModel cuentaDest = cuentaDAO.consultarCuentaPorNumero(cuentaDestino);

        if (cuentaOrigen == null || cuentaDest == null || cuentaOrigen.getSaldo() < valor) {
            System.out.println("Transferencia inválida: Saldo insuficiente o cuenta no encontrada.");
            return;
        }

        OperacionFinanceiraModel operacion = new OperacionFinanceiraModel(
                null, valor, null, cliente.getRut(), cliente.getRut(), "transferencia", "creado", cuentaDestino
        );

        if (operacionFinanceiraDAO.registrarOperacion(operacion)) {
            System.out.println("¡Transferencia realizada con éxito!");
        } else {
            System.out.println("Error al realizar la transferencia.");
        }
    }

    private static void consultarSaldo(ClienteModel cliente) {
        CuentaModel cuenta = cuentaDAO.consultarCuentaPorNumero(cliente.getRut());
        if (cuenta != null) {
            System.out.println("Saldo actual: " + cuenta.getSaldo());
            System.out.println("Fecha de creación: " + cuenta.getFechaCreacion());
        } else {
            System.out.println("Cuenta no encontrada.");
        }
    }
}
