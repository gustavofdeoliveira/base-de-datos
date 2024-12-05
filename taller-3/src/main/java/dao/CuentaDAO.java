package dao;

import config.DatabaseConnection;
import model.CuentaModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CuentaDAO {
    public CuentaModel consultarCuentaPorNumero(int idCuenta) {
        String query = "SELECT * FROM cuenta WHERE numero = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, idCuenta);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new CuentaModel(
                        rs.getInt("numero"),
                        rs.getFloat("saldo"),
                        rs.getDate("fecha_creacion"),
                        rs.getInt("id_cliente")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registrarCuenta(CuentaModel cuenta) {

        String query = "INSERT INTO cuenta (numero, saldo, fecha_creacion, id_cliente) VALUES (?, ?, CURRENT_DATE, ?)";
        try (Connection connn = DatabaseConnection.getConnection();
             PreparedStatement stmtt = connn.prepareStatement(query)) {
            stmtt.setFloat(1, cuenta.getNumero());
            stmtt.setFloat(2, cuenta.getSaldo());
            stmtt.setInt(3, cuenta.getIdCliente());
            stmtt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("Error al registrar cuenta: " + e.getMessage());
            return false;
        }

    }

    public List<CuentaModel> obtenerCuentasInactivas() {
        String sql = "SELECT c.*\n" +
                "FROM cuenta c\n" +
                "LEFT JOIN operaciones_financieras o ON c.id = o.id_cuenta\n" +
                "WHERE o.id IS NULL;\n";
        List<CuentaModel> cuentasInactivas = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                cuentasInactivas.add(new CuentaModel(
                        rs.getInt("id"),
                        rs.getFloat("saldo"),
                        rs.getDate("fecha_creacion"),
                        rs.getInt("id_cliente")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cuentas inactivas: " + e.getMessage());
        }
        return cuentasInactivas;
    }
}

