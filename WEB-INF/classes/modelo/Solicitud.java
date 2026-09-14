package modelo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Solicitud {
    private int id;
    private int idPropiedad;
    private String propiedadTitulo;
    private double propiedadPrecio;
    private int idAgentePropiedad; // auxiliar: dueño de la propiedad, para validar permisos
    private int idCliente;
    private String clienteNombre;
    private String tipoSolicitud; // compra, arriendo
    private String estado; // pendiente, aprobada, rechazada
    private Date fechaSolicitud;
    
    private List<Documento> documentos = new ArrayList<>();

    public Solicitud() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }

    public String getPropiedadTitulo() { return propiedadTitulo; }
    public void setPropiedadTitulo(String propiedadTitulo) { this.propiedadTitulo = propiedadTitulo; }

    public double getPropiedadPrecio() { return propiedadPrecio; }
    public void setPropiedadPrecio(double propiedadPrecio) { this.propiedadPrecio = propiedadPrecio; }

    public int getIdAgentePropiedad() { return idAgentePropiedad; }
    public void setIdAgentePropiedad(int idAgentePropiedad) { this.idAgentePropiedad = idAgentePropiedad; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getClienteNombre() { return clienteNombre; }
    public void setClienteNombre(String clienteNombre) { this.clienteNombre = clienteNombre; }

    public String getTipoSolicitud() { return tipoSolicitud; }
    public void setTipoSolicitud(String tipoSolicitud) { this.tipoSolicitud = tipoSolicitud; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Date getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(Date fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }

    public List<Documento> getDocumentos() { return documentos; }
    public void setDocumentos(List<Documento> documentos) { this.documentos = documentos; }
    
    public void addDocumento(Documento doc) {
        this.documentos.add(doc);
    }

    public static class Documento {
        private int id;
        private int idSolicitud;
        private String nombreArchivo;
        private String rutaArchivo;
        private String tipoDocumento; // identificacion, ingresos, contrato, otro

        public Documento() {}

        public Documento(int id, int idSolicitud, String nombreArchivo, String rutaArchivo, String tipoDocumento) {
            this.id = id;
            this.idSolicitud = idSolicitud;
            this.nombreArchivo = nombreArchivo;
            this.rutaArchivo = rutaArchivo;
            this.tipoDocumento = tipoDocumento;
        }

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public int getIdSolicitud() { return idSolicitud; }
        public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

        public String getNombreArchivo() { return nombreArchivo; }
        public void setNombreArchivo(String nombreArchivo) { this.nombreArchivo = nombreArchivo; }

        public String getRutaArchivo() { return rutaArchivo; }
        public void setRutaArchivo(String rutaArchivo) { this.rutaArchivo = rutaArchivo; }

        public String getTipoDocumento() { return tipoDocumento; }
        public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }
    }
}
