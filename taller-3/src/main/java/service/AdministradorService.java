package service;

import dao.CuentaDAO;
import dao.OperacionFinanceiraDAO;
import model.ClienteModel;
import model.CuentaModel;
import model.OperacionFinanceiraModel;

import java.util.List;
import java.util.Scanner;

public class AdministradorService {
    private static final CuentaDAO cuentaDAO = new CuentaDAO();
    private static final OperacionFinanceiraDAO operacionFinanceiraDAO = new OperacionFinanceiraDAO();

    public static void menuAdministrador(ClienteModel cliente,Scanner scanner) {
        boolean showMenu = true;
        while (showMenu) {
            System.out.println("=== Menú Administrador ===");
            System.out.println("¡Bienvenido, " + cliente.getNombre() + "!");
            System.out.println("1. Consultar historial de transacciones");
            System.out.println("2. Generar Reportes Financieros");
            System.out.println("3. Eliminar usuario");
            System.out.println("4. Salir");
            System.out.print("Seleccione una opción: ");
            int opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1:
                    consultarHistorial(scanner);
                case 2:
                    verCuentasInactivas(scanner);
                case 3:
                    showMenu = false;
                    return;
                default :
                    System.out.println("Opción inválida. Intente nuevamente.");
            }
        }
    }

    private static void consultarHistorial(Scanner scanner) {
        System.out.print("Ingrese el ID del cliente: ");
        int idCliente = scanner.nextInt();
        List<OperacionFinanceiraModel> historial = operacionFinanceiraDAO.consultarHistorialPorCliente(idCliente);

        if (historial.isEmpty()) {
            System.out.println("No se encontraron transacciones.");
        } else {
            System.out.println("Historial de transacciones:");
            for (OperacionFinanceiraModel operacion : historial) {
                System.out.println(operacion);
            }
        }
    }

    private static void verCuentasInactivas(Scanner scanner) {
        System.out.print("Ingrese el período (días) para considerar una cuenta inactiva: ");
        String periodo = scanner.nextLine();
        List<CuentaModel> cuentasInactivas = cuentaDAO.obtenerCuentasInactivas(periodo);

        if (cuentasInactivas.isEmpty()) {
            System.out.println("No se encontraron cuentas inactivas.");
        } else {
            System.out.println("Cuentas inactivas:");
            for (CuentaModel cuenta : cuentasInactivas) {
                System.out.println(cuenta);
            }
        }
    }
}
