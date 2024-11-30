package model;

public class CuentaModel {
    private Integer id;
    private float saldo;
    private String fechaCreacion;
    private int idCliente;

    public CuentaModel(Integer id, float saldo, String fechaCreacion, int idCliente) {
        this.id = id;
        this.saldo = saldo;
        this.fechaCreacion = fechaCreacion;
        this.idCliente = idCliente;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getSaldo() {
        return saldo;
    }

    public void setSaldo(float saldo) {
        this.saldo = saldo;
    }

    public String getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(String fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public int getIdCliente() {
        return idCliente;
    }
}
