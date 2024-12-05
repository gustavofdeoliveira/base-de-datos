package service;

import dao.ClienteDAO;
import dao.CuentaDAO;
import dao.OperacionFinanceiraDAO;
import model.ClienteModel;
import model.CuentaModel;
import model.OperacionFinanceiraModel;

import java.util.List;
import java.util.Scanner;


public class AdministradorService {
    private static final ClienteDAO clienteDAO = new ClienteDAO();
    private static final CuentaDAO cuentaDAO = new CuentaDAO();
    private  static  final OperacionFinanceiraDAO operacionFinanceiraDAO = new OperacionFinanceiraDAO();

    public static void menuAdministrador(ClienteModel cliente, Scanner scanner) {
        boolean showMenu = true;
        while (showMenu) {
            System.out.println("=== Menú Administrador ===");
            System.out.println("¡Bienvenido, " + cliente.getNombre() + "!");
            System.out.println("1. Consultar historial de transacciones");
            System.out.println("2. Generar Reportes Financieros");
            System.out.println("3. Vista de Cuentas Inactivas");
            System.out.println("4. Configuración de Usuarios");
            System.out.println("5. Salir");
            System.out.print("Seleccione una opción: ");
            int opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1:
                    consultarHistorial(scanner);
                    break;
                case 2:
                    verCuentasInactivas(scanner);
                    break;
                case 3:
                    configuracionUsuarios(scanner);
                    break;
                case 5:
                    showMenu = false;
                    return;
                default:
                    System.out.println("Opción inválida. Intente nuevamente.");
            }
        }
    }

    private static void configuracionUsuarios(Scanner scanner) {
        boolean showSubMenu = true;
        while (showSubMenu) {
            System.out.println("=== Configuración de Usuarios ===");
            System.out.println("1. Agregar Cliente y Cuenta");
            System.out.println("2. Editar Cliente");
            System.out.println("3. Eliminar Cliente");
            System.out.println("4. Volver al Menú Principal");
            System.out.print("Seleccione una opción: ");
            int opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1:
                    agregarClienteYCuenta(scanner);
                    break;
                case 2:
                    editarCliente(scanner);
                    break;
                case 3:
                    eliminarCliente(scanner);
                    break;
                case 4:
                    showSubMenu = false;
                    break;
                default:
                    System.out.println("Opción inválida. Intente nuevamente.");
            }
        }
    }

    private static void verCuentasInactivas(Scanner scanner) {
        List<CuentaModel> cuentasInactivas = cuentaDAO.obtenerCuentasInactivas();

        if (cuentasInactivas.isEmpty()) {
            System.out.println("No se encontraron cuentas inactivas.");
        } else {
            System.out.println("Cuentas inactivas:");
            for (CuentaModel cuenta : cuentasInactivas) {
                System.out.println(cuenta);
            }
        }
    }

    private static void consultarHistorial(Scanner scanner) {
        System.out.print("Ingrese el ID del cliente: ");
        int idCliente = scanner.nextInt();
        scanner.nextLine(); // Consumir a quebra de linha

        List<OperacionFinanceiraModel> historial = operacionFinanceiraDAO.consultarHistorialPorCliente(idCliente);

        if (historial.isEmpty()) {
            System.out.println("No se encontraron transacciones para este cliente.");
        } else {
            System.out.println("Historial de transacciones:");
            for (OperacionFinanceiraModel operacion : historial) {
                System.out.println("ID Operación: " + operacion.getId());
                System.out.println("Tipo: " + operacion.getTipo());
                System.out.println("Valor: " + operacion.getValor());
                System.out.println("Fecha: " + operacion.getFechaCreacion());
                System.out.println("Estado: " + operacion.getStatus());
                System.out.println("ID Cuenta Asociada: " + operacion.getIdCuenta());
                System.out.println("--------------------------");
            }
        }
    }



    private static void agregarClienteYCuenta(Scanner scanner) {
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
            System.out.println("¡Cliente registrado exitosamente!");
            System.out.print("Ingrese el saldo inicial de la cuenta: ");
            float saldoInicial = scanner.nextFloat();
            scanner.nextLine();

            CuentaModel nuevaCuenta = new CuentaModel(0, saldoInicial, null, rut);
            if (cuentaDAO.registrarCuenta(nuevaCuenta)) {
                System.out.println("¡Cuenta registrada exitosamente!");
            } else {
                System.out.println("Error al registrar la cuenta.");
            }
        } else {
            System.out.println("Error al registrar el cliente.");
        }
    }

    private static void editarCliente(Scanner scanner) {
        System.out.print("Ingrese el RUT del cliente a editar: ");
        int rut = scanner.nextInt();
        scanner.nextLine();
        ClienteModel clienteExistente = clienteDAO.consultarClientePorRut(rut);

        if (clienteExistente == null) {
            System.out.println("Cliente no encontrado.");
            return;
        }

        System.out.print("Nuevo nombre (actual: " + clienteExistente.getNombre() + "): ");
        String nuevoNombre = scanner.nextLine();
        System.out.print("Nueva dirección (actual: " + clienteExistente.getDireccion() + "): ");
        String nuevaDireccion = scanner.nextLine();
        System.out.print("Nuevo correo electrónico (actual: " + clienteExistente.getEmail() + "): ");
        String nuevoEmail = scanner.nextLine();
        System.out.print("Nuevo teléfono (actual: " + clienteExistente.getTelefono() + "): ");
        String nuevoTelefono = scanner.nextLine();
        System.out.print("Nueva contraseña: ");
        String nuevaContrasena = scanner.nextLine();

        clienteExistente.setNombre(nuevoNombre.isEmpty() ? clienteExistente.getNombre() : nuevoNombre);
        clienteExistente.setDireccion(nuevaDireccion.isEmpty() ? clienteExistente.getDireccion() : nuevaDireccion);
        clienteExistente.setEmail(nuevoEmail.isEmpty() ? clienteExistente.getEmail() : nuevoEmail);
        clienteExistente.setTelefono(nuevoTelefono.isEmpty() ? clienteExistente.getTelefono() : nuevoTelefono);
        clienteExistente.setContrasena(nuevaContrasena.isEmpty() ? clienteExistente.getContrasena() : nuevaContrasena);

        if (clienteDAO.actualizarCliente(clienteExistente)) {
            System.out.println("¡Cliente actualizado exitosamente!");
        } else {
            System.out.println("Error al actualizar el cliente.");
        }
    }

    private static void eliminarCliente(Scanner scanner) {
        System.out.print("Ingrese el RUT del cliente a eliminar: ");
        int rut = scanner.nextInt();
        scanner.nextLine();

        if (clienteDAO.eliminarCliente(rut)) {
            System.out.println("¡Cliente eliminado exitosamente!");
        } else {
            System.out.println("Error al eliminar el cliente.");
        }
    }
}
