package dao;

import config.DatabaseConnection;
import model.OperacionFinanceiraModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OperacionFinanceiraDAO {
    public List<OperacionFinanceiraModel> consultarHistorialPorCliente(int idCliente) {
        List<OperacionFinanceiraModel> operaciones = new ArrayList<>();
        String query = "SELECT * FROM operacion_financiera WHERE id_cliente = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                operaciones.add(new OperacionFinanceiraModel(
                        rs.getInt("id"),
                        rs.getFloat("valor"),
                        rs.getDate("fecha_creacion"),
                        rs.getInt("cuenta_operacion"),
                        rs.getInt("id_cliente"),
                        rs.getString("tipo"),
                        rs.getString("status"),
                        rs.getInt("id_cuenta")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return operaciones;
    }

    public boolean registrarOperacion(OperacionFinanceiraModel operacion) {
        String insertQuery = "INSERT INTO operacion_financiera (valor, fecha_creacion, cuenta_operacion, id_cliente, tipo, status, id_cuenta) VALUES (?, CURRENT_DATE, ?, ?, ?, ?, ?)";
        String updateSaldoQuery = "UPDATE cuenta SET saldo = saldo + ? WHERE numero = ?";
        String verificarSaldoQuery = "SELECT saldo FROM cuenta WHERE numero = ?";
        String verificarCuentaDestinoQuery = "SELECT 1 FROM cuenta WHERE numero = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Insertar la operación financiera
            try (PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
                stmt.setFloat(1, operacion.getValor());
                stmt.setInt(2, operacion.getCuentaOperacion());
                stmt.setInt(3, operacion.getIdCliente());
                stmt.setString(4, operacion.getTipo());
                stmt.setString(5, operacion.getStatus());
                stmt.setInt(6, operacion.getIdCuenta());
                stmt.executeUpdate();
            }

            if (operacion.getTipo().equalsIgnoreCase("depósito")) {
                // Actualizar saldo para depósito
                try (PreparedStatement stmt = conn.prepareStatement(updateSaldoQuery)) {
                    stmt.setFloat(1, operacion.getValor());
                    stmt.setInt(2, operacion.getCuentaOperacion());
                    stmt.executeUpdate();
                }
            } else if (operacion.getTipo().equalsIgnoreCase("retiro")) {
                // Verificar si hay saldo suficiente para el retiro
                try (PreparedStatement stmt = conn.prepareStatement(verificarSaldoQuery)) {
                    stmt.setInt(1, operacion.getCuentaOperacion());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        float saldoActual = rs.getFloat("saldo");
                        if (saldoActual < operacion.getValor()) {
                            conn.rollback();
                            System.out.println("Saldo insuficiente para retiro.");
                            return false;
                        }
                    }
                }

                // Actualizar saldo para retiro
                try (PreparedStatement stmt = conn.prepareStatement(updateSaldoQuery)) {
                    stmt.setFloat(1, -operacion.getValor()); // Sustracción
                    stmt.setInt(2, operacion.getCuentaOperacion());
                    stmt.executeUpdate();
                }
            } else if (operacion.getTipo().equalsIgnoreCase("transferencia")) {
                // Verificar saldo de la cuenta de origen
                try (PreparedStatement stmt = conn.prepareStatement(verificarSaldoQuery)) {
                    stmt.setInt(1, operacion.getCuentaOperacion());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        float saldoActual = rs.getFloat("saldo");
                        if (saldoActual < operacion.getValor()) {
                            conn.rollback();
                            System.out.println("Saldo insuficiente para transferencia.");
                            return false;
                        }
                    }
                }

                // Verificar si la cuenta de destino existe
                try (PreparedStatement stmt = conn.prepareStatement(verificarCuentaDestinoQuery)) {
                    stmt.setInt(1, operacion.getIdCuenta());
                    ResultSet rs = stmt.executeQuery();
                    if (!rs.next()) {
                        conn.rollback();
                        System.out.println("La cuenta de destino no existe.");
                        return false;
                    }
                }

                // Actualizar saldo de la cuenta de origen
                try (PreparedStatement stmt = conn.prepareStatement(updateSaldoQuery)) {
                    stmt.setFloat(1, -operacion.getValor()); // Sustracción
                    stmt.setInt(2, operacion.getCuentaOperacion());
                    stmt.executeUpdate();
                }

                // Actualizar saldo de la cuenta de destino
                try (PreparedStatement stmt = conn.prepareStatement(updateSaldoQuery)) {
                    stmt.setFloat(1, operacion.getValor());
                    stmt.setInt(2, operacion.getIdCuenta());
                    stmt.executeUpdate();
                }
            }

            conn.commit(); // Confirmar la transacción
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
