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
                        rs.getString("fecha_creacion"),
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
        String query = "INSERT INTO operacion_financiera (valor, fecha_creacion, cuenta_operacion, id_cliente, tipo, status, id_cuenta) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setFloat(1, operacion.getValor());
            stmt.setString(2, operacion.getFechaCreacion());
            stmt.setInt(3, operacion.getCuentaOperacion());
            stmt.setInt(4, operacion.getIdCliente());
            stmt.setString(5, operacion.getTipo());
            stmt.setString(6, operacion.getStatus());
            stmt.setInt(7, operacion.getIdCuenta());
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
