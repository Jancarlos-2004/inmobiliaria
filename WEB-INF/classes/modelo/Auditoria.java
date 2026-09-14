package modelo;

import java.util.Date;

public class Auditoria {
    private int id;
    private Integer idUsuario; // Nullable if visitor (failed login)
    private String usuarioCorreo;
    private String accion;
    private String tablaAfectada;
    private Integer registroId;
    private Date fechaHora;
    private String detalles;

    public Auditoria() {}

    public Auditoria(int id, Integer idUsuario, String usuarioCorreo, String accion, String tablaAfectada, Integer registroId, Date fechaHora, String detalles) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.usuarioCorreo = usuarioCorreo;
        this.accion = accion;
        this.tablaAfectada = tablaAfectada;
        this.registroId = registroId;
        this.fechaHora = fechaHora;
        this.detalles = detalles;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public String getUsuarioCorreo() { return usuarioCorreo; }
    public void setUsuarioCorreo(String usuarioCorreo) { this.usuarioCorreo = usuarioCorreo; }

    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }

    public String getTablaAfectada() { return tablaAfectada; }
    public void setTablaAfectada(String tablaAfectada) { this.tablaAfectada = tablaAfectada; }

    public Integer getRegistroId() { return registroId; }
    public void setRegistroId(Integer registroId) { this.registroId = registroId; }

    public Date getFechaHora() { return fechaHora; }
    public void setFechaHora(Date fechaHora) { this.fechaHora = fechaHora; }

    public String getDetalles() { return detalles; }
    public void setDetalles(String detalles) { this.detalles = detalles; }
}
