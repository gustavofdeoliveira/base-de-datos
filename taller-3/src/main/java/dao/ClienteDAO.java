package dao;

import model.ClienteModel;
import config.DatabaseConnection;
import model.CuentaModel;

import java.sql.*;

public class ClienteDAO {
    public ClienteModel iniciarSesion(String email, String contrasena) {
        String consulta = "SELECT * FROM cliente WHERE email = ? AND contrasena = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            stmt.setString(1, email);
            stmt.setString(2, contrasena);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new ClienteModel(
                        rs.getInt("rut"),
                        rs.getString("nombre"),
                        rs.getString("direccion"),
                        rs.getString("email"),
                        rs.getString("telefone"),
                        rs.getString("contrasena"),
                        rs.getString("tipo")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static CuentaModel consultaSaldo(int id_cliente) {
        String consulta = "SELECT * FROM cuenta WHERE id_cliente = ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            stmt.setInt(1, id_cliente);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new CuentaModel(
                        rs.getInt("int"),
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

    public boolean registrarCliente(ClienteModel cliente) {
        String consulta = "INSERT INTO cliente (rut, nombre, direccion, email, telefone, contrasena, tipo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            stmt.setInt(1, cliente.getRut());
            stmt.setString(2, cliente.getNombre());
            stmt.setString(3, cliente.getDireccion());
            stmt.setString(4, cliente.getEmail());
            stmt.setString(5, cliente.getTelefono());
            stmt.setString(6, cliente.getContrasena());
            stmt.setString(7, cliente.getTipo());
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

