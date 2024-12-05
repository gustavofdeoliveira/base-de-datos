package model;

import java.sql.Date;

public class CuentaModel {
    private Integer numero;
    private float saldo;
    private Date fechaCreacion;
    private int idCliente;

    public CuentaModel(Integer numero, float saldo, Date fechaCreacion, int idCliente) {
        this.numero = numero;
        this.saldo = saldo;
        this.fechaCreacion = fechaCreacion;
        this.idCliente = idCliente;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public float getSaldo() {
        return saldo;
    }

    public void setSaldo(float saldo) {
        this.saldo = saldo;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public int getIdCliente() {
        return idCliente;
    }
}
