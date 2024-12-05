package model;

import java.util.Date;

public class OperacionFinanceiraModel {
    private Integer id;
    private float valor;
    private int cuentaOperacion;
    private int idCliente;
    private String tipo;
    private String status;
    private int idCuenta;
    private Date fechaCreacion;

    public OperacionFinanceiraModel(Integer id, float valor, Date fechaCreacion, int cuentaOperacion, int idCliente, String tipo, String status, int idCuenta) {
        this.id = id;
        this.valor = valor;
        this.fechaCreacion = fechaCreacion;
        this.cuentaOperacion = cuentaOperacion;
        this.idCliente = idCliente;
        this.tipo = tipo;
        this.status = status;
        this.idCuenta = idCuenta;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getValor() {
        return valor;
    }

    public void setValor(float valor) {
        this.valor = valor;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public int getCuentaOperacion() {
        return cuentaOperacion;
    }

    public void setCuentaOperacion(int cuentaOperacion) {
        this.cuentaOperacion = cuentaOperacion;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getIdCuenta() {
        return idCuenta;
    }

    public void setIdCuenta(int idCuenta) {
        this.idCuenta = idCuenta;
    }
}
