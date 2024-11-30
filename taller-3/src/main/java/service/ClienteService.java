package service;

import dao.ClienteDAO;
import model.ClienteModel;
import model.CuentaModel;
import model.OperacionFinanceiraModel;

import java.util.Scanner;

public class ClienteService {
    private static ClienteDAO clienteDAO = new ClienteDAO();

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
            System.out.println("¡Registro exitoso!");
        } else {
            System.out.println("Error al registrar al cliente.");
        }
    }

    public static void registrarDeposito(Scanner scanner, ClienteModel cliente) {
        System.out.print("Valor: ");
        float valor = scanner.nextInt();
        scanner.nextLine();
        System.out.print("Dirección: ");
        String direccion = scanner.nextLine();
        System.out.print("Correo electrónico: ");
        String email = scanner.nextLine();
        System.out.print("Teléfono: ");
        String telefono = scanner.nextLine();
        System.out.print("Contraseña: ");
        String contrasena = scanner.nextLine();

        OperacionFinanceiraModel nuevoOperacion = new OperacionFinanceiraModel(
                null,
                valor,
                null,
                cliente.getRut(),

                "depósitos",
                "creado",
                cliente.getRut()
        );
        if (clienteDAO.registrarCliente(nuevoOperacion)) {
            System.out.println("¡Registro exitoso!");
        } else {
            System.out.println("Error al registrar al cliente.");
        }
    }

    private static void menuCliente(ClienteModel cliente, Scanner scanner) {
        boolean showMenu = true;
        while (showMenu) {
            System.out.println("=== Menú Cliente ===");
            System.out.println("¡Bienvenido, " + cliente.getNombre() + "!");
            System.out.println("1. Consultar saldo");
            System.out.println("2. Realizar deposito");
            System.out.println("3. Realizar retiro");
            System.out.println("4. Realizar transferencia");
            System.out.println("5. Consultar historial de transacciones");
            System.out.println("6. Salir");
            System.out.println("Seleccione una opcion: ");
            int opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1:
                    CuentaModel consulta = ClienteDAO.consultaSaldo(cliente.getRut());
                    System.out.println("Saldo: " + consulta.getSaldo());
                    System.out.println("Fecha de criacion: " + consulta.getFechaCreacion());
                    break;
                case 2:

                    break;
                case 3:
                case 4:
                case 5:

                case 6:
                    System.out.println("Saliendo...");
                    return;
                default:
                    System.out.println("Opción inválida. Intente de nuevo.");
            }

        }
    }

}