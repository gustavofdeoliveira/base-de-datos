package dao;

import model.ClienteModel;
import config.DatabaseConnection;

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
                ClienteModel resultCliente = new ClienteModel(
                        rs.getInt("rut"),
                        rs.getString("nombre"),
                        rs.getString("direccion"),
                        rs.getString("email"),
                        rs.getString("telefono"),
                        rs.getString("contrasena"),
                        rs.getString("tipo"));

                return resultCliente;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registrarCliente(ClienteModel cliente) {
        String sql = "INSERT INTO cliente (rut, nombre, direccion, email, telefono, contrasena, tipo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
            System.err.println("Error al registrar cliente: " + e.getMessage());
            return false;
        }
    }

    public ClienteModel consultarClientePorRut(int rut) {
        String sql = "SELECT * FROM cliente WHERE rut = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, rut);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new ClienteModel(
                        rs.getInt("rut"),
                        rs.getString("nombre"),
                        rs.getString("direccion"),
                        rs.getString("email"),
                        rs.getString("telefono"),
                        rs.getString("contrasena"),
                        rs.getString("tipo")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar cliente: " + e.getMessage());
        }
        return null;
    }

    public boolean actualizarCliente(ClienteModel cliente) {
        String sql = "UPDATE cliente SET nombre = ?, direccion = ?, email = ?, telefono = ?, contrasena = ? WHERE rut = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, cliente.getNombre());
            stmt.setString(2, cliente.getDireccion());
            stmt.setString(3, cliente.getEmail());
            stmt.setString(4, cliente.getTelefono());
            stmt.setString(5, cliente.getContrasena());
            stmt.setInt(6, cliente.getRut());
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarCliente(int rut) {
        String deleteCuentaQuery = "DELETE FROM cuenta WHERE id_cliente = ?";
        String deleteClienteQuery = "DELETE FROM cliente WHERE rut = ?";


        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false); // Inicia uma transação

            // Deletar contas associadas ao cliente
            try (PreparedStatement stmtCuenta = conn.prepareStatement(deleteCuentaQuery)) {
                stmtCuenta.setInt(1, rut);
                stmtCuenta.executeUpdate();
            }

            // Deletar o cliente
            try (PreparedStatement stmtCliente = conn.prepareStatement(deleteClienteQuery)) {
                stmtCliente.setInt(1, rut);
                stmtCliente.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Erro ao deletar cliente: " + e.getMessage());
            return false;
        }
    }

}
