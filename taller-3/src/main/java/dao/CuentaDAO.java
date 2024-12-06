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

    public List<CuentaModel> obtenerCuentasInactivasPorPeriodo(int dias) {
        String sql = "SELECT c.* " +
                "FROM cuenta c " +
                "LEFT JOIN operacion_financiera of ON c.numero = of.id_cuenta " +
                "GROUP BY c.numero, c.saldo, c.fecha_creacion, c.id_cliente " +
                "HAVING MAX(of.fecha_creacion) IS NULL " +
                "   OR (CURRENT_DATE - MAX(of.fecha_creacion)) > ?";

        List<CuentaModel> cuentasInactivas = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, dias);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                cuentasInactivas.add(new CuentaModel(
                        rs.getInt("numero"),
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

    public float obtenerSaldoPromedio() {
        String sql = "SELECT AVG(saldo) AS saldo_promedio FROM cuenta";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getFloat("saldo_promedio");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener saldo promedio: " + e.getMessage());
        }
        return 0;
    }

    public List<CuentaModel> obtenerCuentasMasActivas() {
        String sql = "SELECT c.numero, c.saldo, c.fecha_creacion, c.id_cliente, COUNT(o.id) AS total_transacciones " +
                "FROM cuenta c " +
                "INNER JOIN operacion_financiera o ON c.numero = o.id_cuenta " +
                "GROUP BY c.numero, c.saldo, c.fecha_creacion, c.id_cliente " +
                "ORDER BY total_transacciones DESC LIMIT 5";
        List<CuentaModel> cuentasMasActivas = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CuentaModel cuenta = new CuentaModel(
                        rs.getInt("numero"),
                        rs.getFloat("saldo"),
                        rs.getDate("fecha_creacion"),
                        rs.getInt("id_cliente")
                );
                cuentasMasActivas.add(cuenta);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cuentas más activas: " + e.getMessage());
        }
        return cuentasMasActivas;
    }

    public float obtenerIngresosNetos() {
        String sql = "SELECT " +
                "SUM(CASE WHEN of.tipo = 'depósito' THEN of.valor ELSE 0 END) - " +
                "SUM(CASE WHEN of.tipo = 'retiro' THEN of.valor ELSE 0 END) AS ingresos_netos " +
                "FROM operacion_financiera of";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getFloat("ingresos_netos");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener ingresos netos: " + e.getMessage());
        }
        return 0;
    }

}

