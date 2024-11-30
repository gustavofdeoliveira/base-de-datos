package dao;

import config.DatabaseConnection;
import model.CuentaModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CuentaDAO {
    public CuentaModel consultarCuentaPorId(int idCuenta) {
        String query = "SELECT * FROM cuenta WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, idCuenta);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new CuentaModel(
                        rs.getInt("id"),
                        rs.getFloat("saldo"),
                        rs.getString("fecha_creacion"),
                        rs.getInt("id_cliente")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<CuentaModel> obtenerCuentasInactivas(String periodo) {
        List<CuentaModel> cuentas = new ArrayList<>();
        String query = "SELECT * FROM cuenta WHERE DATEDIFF(CURRENT_DATE, fecha_creacion) > ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, Integer.parseInt(periodo));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                cuentas.add(new CuentaModel(
                        rs.getInt("id"),
                        rs.getFloat("saldo"),
                        rs.getString("fecha_creacion"),
                        rs.getInt("id_cliente")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cuentas;
    }
}

