package service;

import model.ClienteModel;

import java.util.Scanner;

public class SistemaBancoService {
        public void iniciar() {
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("¡Bienvenido al Sistema Bancario!");
            System.out.println("1. Iniciar sesión");
            System.out.println("2. Registrarse");
            System.out.println("3. Salir");
            System.out.print("Elija una opción: ");
            int opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1:
                    ClienteService.iniciarSesion(scanner);
                    break;
                case 2:
                    ClienteService.registrarse(scanner);
                    break;
                case 3:
                    System.out.println("Saliendo...");
                    scanner.close();
                    return;
                default:
                    System.out.println("Opción inválida. Intente de nuevo.");
            }
        }
    }
}

